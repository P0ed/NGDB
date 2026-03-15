struct API {
	var discover: (Int) async throws -> Discover
}

/// API implementation
extension API {

	static func main(apiKey: String?) -> API {
		let session = NetworkSession.urlSession(apiKey: apiKey)

		return API(
			discover: { page in
				try await session.get(url: .discover, args: ["page": "\(page)"])
			}
		)
	}
}

extension API {

	struct Error: Swift.Error, Decodable {
		var message: String
	}

	struct Discover: Decodable {

	}
}
