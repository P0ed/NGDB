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

	static func findOrCreate(remote: API.Movie, in context: NSManagedObjectContext) -> Movie {
		let movie = findOrCreate(id: remote.id, in: context)
		movie.fill(remote)
		return movie
	}

	func fill(_ remote: API.Movie) {
		title = remote.title
		overview = remote.overview
		poster = remote.poster_path
		releaseDate = remote.release_date

		if let genres = remote.genres, let managedObjectContext {
			typedGenres = genres.map { genre in
				Genre.findOrCreate(genre, in: managedObjectContext)
			}
		}
	}

	var posterURL: URL? {
		poster.flatMap { path in .image(path: path) }
	}

	var typedGenres: [Genre] {
		get { (genres?.allObjects as? [Genre]) ?? [] }
		set { genres = NSSet(array: newValue) }
	}

	@MainActor
	func load(using api: API) async throws {
		let remote = try await api.details(Int(uid))
		try await performBackgroundTask { [ref] context in
			ref.deref(in: context).fill(remote)
			try context.save()
		}
	}
}
