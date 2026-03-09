@MainActor
let api = API.main

struct API {

}

/// API implementation
extension API {

	static var main: API {
		API(

		)
	}
}

extension API {

	struct Error: Swift.Error, Codable {
		
	}
}
