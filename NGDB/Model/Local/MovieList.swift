import CoreData

extension MovieList {

	static func discover(in context: NSManagedObjectContext) -> MovieList {
		findOrCreate("discover", in: context)
	}

	static func search(in context: NSManagedObjectContext) -> MovieList {
		findOrCreate("search", in: context)
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

	var isComplete: Bool {
		page != 0 && page >= totalPages
	}

	var typedIndices: Set<MovieIndex> {
		indices as? Set<MovieIndex> ?? []
	}

	func reset(saving: Bool = false) {
		page = 0
		totalPages = 0
		updatedAt = .distantPast
		indices = []
		if saving { try? managedObjectContext?.save() }
	}

	@MainActor
	func load(using api: API) async throws {
		guard !isComplete || query != .none else { return }

		let response = if let query {
			try await api.search(query)
		} else {
			try await api.discover(Int(page) + 1)
		}
		try await performBackgroundTask { [ref, query] context in
			let list = ref.deref(in: context)
			if query != .none { list.reset() }
			try list.fill(response)
			try context.save()
		}
	}

	private func fill(_ remote: API.List) throws {
		let context = try unwrap(managedObjectContext)

		page = Int32(remote.page)
		updatedAt = .now
		totalPages = Int32(remote.total_pages)

		let movies = remote.results.map { item in
			Movie.findOrCreate(remote: item, in: context)
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
