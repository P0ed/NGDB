import CoreData

extension MovieList {

	static func discover(in context: NSManagedObjectContext) -> MovieList {
		findOrCreate("discover", in: context)
	}

	static func findOrCreate(_ uid: String, in context: NSManagedObjectContext) -> MovieList {
		let list = MovieList.find(.equals(\MovieList.uid, uid), in: context)

		if let list {
			return list
		} else {
			let list = MovieList(context: context)
			list.uid = uid
			return list
		}
	}

	var isOutdated: Bool {
		updatedAt.map { $0.timeIntervalSinceNow > 30.0 * 60.0 } ?? true
	}

	var isComplete: Bool { page > totalPages }

	var typedIndices: Set<MovieIndex> { indices as? Set<MovieIndex> ?? [] }

	func reset() {
		page = 0
		totalPages = 0
		updatedAt = .distantPast
		indices = []
	}

	@MainActor
	func load(using api: API) async throws {
		guard !isComplete else { return }

		let response = try await api.discover(Int(page + 1))
		try await performBackgroundTask { [ref] context in
			let list = ref.deref(in: context)
			try list.fill(response)
			try context.save()
		}
	}

	private func fill(_ remote: API.Discover) throws {
		let context = try unwrap(managedObjectContext)

		page = Int32(remote.page)
		updatedAt = .now
		totalPages = Int32(remote.total_pages)

		let movies = remote.results.map { item in
			Movie.findOrCreate(item, in: context)
		}

		let storedIndices = typedIndices
		let storedItemIDs = Set<Int64>(storedIndices.compactMap { $0.movie?.uid })

		let newIndices: [MovieIndex] = movies.compactMap { movie in
			guard !storedItemIDs.contains(movie.uid) else { return nil }

			let index = MovieIndex(context: context)
			index.movie = movie
			index.list = self
			return index
		}

		let nextIndex = storedIndices.map(\.index).max().map { $0 + 1 } ?? 0
		newIndices.enumerated().forEach { offset, index in
			index.index = nextIndex + Int32(offset)
		}
	}
}
