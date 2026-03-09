@MainActor
let api = API.main

struct API {
	var discover: (Int) async throws -> Discover
}

/// API implementation
extension API {

	static var main: API {
		let session = NetworkSession.urlSession

		return API(
			discover: { page in try await session.get(url: .discover, args: ["page": "\(page)"]) }
		)
	}
}

extension API {

	struct Error: Swift.Error, Decodable {

	}

	struct Discover: Decodable {

	}
}
