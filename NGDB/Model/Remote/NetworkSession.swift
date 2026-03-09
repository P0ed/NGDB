import Foundation

struct NetworkSession: Sendable {
	var http: @Sendable (URLRequest) async throws -> Response
}

extension NetworkSession {

	struct Response {
		var meta: HTTPURLResponse
		var data: Data
	}

	static var urlSession: Self {
		Self { [session = URLSession(configuration: .default)] request in
			let (data, rawMeta) = try await session.data(for: modifying(request) { request in
//				request.setValue("Bearer \("token")", forHTTPHeaderField: "Authorization")
				request.setValue("accept", forHTTPHeaderField: "application/json")
				request.url?.modify { cpts in
					cpts.queryItems.append(URLQueryItem(name: "api_key", value: "key"))
				}
			})
			return Response(meta: try cast(rawMeta), data: data)
		}
	}

	func request<Body: Encodable>(
		method: String = "GET",
		url: URL,
		args: [String: String] = [:],
		body: Body? = Data?.none
	) async throws -> Response {
		try await _request(method: method, url: url, args: args, body: body)
	}

	private func _request<Body: Encodable>(
		method: String = "GET",
		url: URL,
		args: [String: String] = [:],
		body: Body? = Data?.none,
		retry: Int = 0
	) async throws -> Response {
		var request = URLRequest(
			url: url.modifying { cpts in
				if args.isEmpty { return }
				cpts.queryItems = args.map(URLQueryItem.init)
			}
		)
		request.httpMethod = method
		if let body {
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = try JSONEncoder().encode(body)
		}
		let response = try await http(request)

		return response
	}

	func get<D: Decodable>(url: URL, args: [String: String] = [:]) async throws -> D {
		let response = try await request(url: url, args: args)
		do {
			return try JSONDecoder.api.decode(D.self, from: response.data)
		} catch {
			throw (try? JSONDecoder().decode(API.Error.self, from: response.data)) ?? error
		}
	}

	func post<E: Encodable, D: Decodable>(url: URL, body: E? = Data?.none) async throws -> D {
		let response = try await request(method: "POST", url: url, body: body)
		do {
			return try JSONDecoder.api.decode(D.self, from: response.data)
		} catch {
			throw (try? JSONDecoder().decode(API.Error.self, from: response.data)) ?? error
		}
	}

	func post<E: Encodable>(url: URL, body: E? = Data?.none) async throws -> Void {
		let response = try await request(method: "POST", url: url, body: body)
		guard response.meta.statusCode == 200 else {
			throw try JSONDecoder().decode(API.Error.self, from: response.data)
		}
	}

	func delete(url: URL) async throws -> Void {
		let response = try await request(method: "DELETE", url: url)
		guard response.meta.statusCode == 204 || response.meta.statusCode == 200 else {
			throw try JSONDecoder().decode(API.Error.self, from: response.data)
		}
	}
}

private extension JSONDecoder {

	static var api: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .custom { decoder in
			let container = try decoder.singleValueContainer()
			let fmt = ISO8601DateFormatter()
			fmt.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
			let dateStr = try container.decode(String.self)
			guard let date = fmt.date(from: dateStr) else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Cannot decode date string: \(dateStr)"
				)
			}
			return date
		}
		return decoder
	}
}

extension URLResponse {

	var httpResponse: HTTPURLResponse? {
		self as? HTTPURLResponse
	}

	var requestID: String? {
		httpResponse?.allHeaderFields["x-request-id"].map { val in "\(val)" }
	}

	var contentType: String? {
		httpResponse?.allHeaderFields["Content-Type"].map { val in "\(val)" }
	}
}
