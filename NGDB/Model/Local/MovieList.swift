import SwiftData
import Foundation

@Model
final class MovieList {
	@Attribute(.unique)
	var identifier: String

	var page: Int = 0
	var isComplete: Bool = false
	var updatedAt: Date = Date.distantPast

	@Relationship(deleteRule: .cascade, inverse: \MovieIndex.list)
	var indices: [MovieIndex] = []

	init(identifier: String) {
		self.identifier = identifier
	}
}

@Model
final class MovieIndex {
	var index: Int

	@Relationship(deleteRule: .nullify)
	var movie: Movie?

	@Relationship(deleteRule: .nullify)
	var list: MovieList?

	init(index: Int) {
		self.index = index
	}
}

extension MovieList {

	static func main(in context: ModelContext) -> MovieList {
		findOrCreate("mian", in: context)
	}

	static func findOrCreate(_ identifier: String, in context: ModelContext) -> MovieList {
		let lists = (try? context.fetch(FetchDescriptor<MovieList>(
			predicate: #Predicate<MovieList> { $0.identifier == identifier }
		))) ?? []

		if !lists.isEmpty {
			return lists[0]
		} else {
			let list = MovieList(identifier: identifier)
			context.insert(list)
			return list
		}
	}

	func reset() {
		page = 0
		isComplete = false
		updatedAt = .distantPast
		indices = []
	}

	func load() async throws {
		guard !isComplete else { return }

		page += 1
		let response = try await api.discover(page)
		try fill(response)
		try modelContext?.save()
	}

	private func fill(_ remote: API.Discover) throws {
		updatedAt = .now
	}
}
