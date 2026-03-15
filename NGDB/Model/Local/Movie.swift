import CoreData

extension Movie {

	static func findOrCreate(id: Int, in context: NSManagedObjectContext) -> Movie {
		let movie = Movie.find(.equals(\Movie.uid, Int64(id)), in: context)

		if let movie {
			return movie
		} else {
			let movie = Movie(context: context)
			movie.uid = Int64(id)
			return movie
		}
	}

	static func findOrCreate(_ remote: API.DiscoverResult, in context: NSManagedObjectContext) -> Movie {
		let movie = findOrCreate(id: remote.id, in: context)
		movie.fill(remote)
		return movie
	}

	func fill(_ remote: API.DiscoverResult) {
		title = remote.title
		overview = remote.overview
		poster = remote.poster_path
		releaseDate = remote.release_date
	}

	var posterURL: URL? {
		poster.flatMap { path in
			.none
		}
	}
}
