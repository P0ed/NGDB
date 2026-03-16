struct API {
	var discover: (Int) async throws -> List
	var search: (String) async throws -> List
	var details: (Int) async throws -> Movie
}

/// API implementation
extension API {

	static func main(apiKey: String?) -> API {
		let session = NetworkSession.urlSession(apiKey: apiKey)

		return API(
			discover: { page in
				try await session.get(url: .discover, args: ["page": "\(page)"])
			},
			search: { query in
				try await session.get(url: .search, args: ["query": query])
			},
			details: { id in
				try await session.get(url: .details(id))
			}
		)
	}
}

extension API {

	struct Error: Swift.Error, Decodable {
		var status_code: Int
		var status_message: String
	}

	struct List: Decodable {
		var page: Int
		var total_pages: Int
		var total_results: Int
		var results: [Movie]
	}

	struct Movie: Decodable {
		var id: Int
		var title: String
		var adult: Bool
		var backdrop_path: String?
		var genre_ids: [Int]?
		var genres: [Genre]?
		var original_language: String
		var original_title: String
		var overview: String
		var popularity: Float
		var poster_path: String?
		var release_date: String
		var vote_average: Float
		var vote_count: Int
		var video: Bool
	}

	struct Genre: Decodable {
		var id: Int
		var name: String
	}
}
