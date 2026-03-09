import SwiftData

@Model
final class MovieList {
	@Attribute(.unique)
	var identifier: String

	@Relationship(deleteRule: .nullify, inverse: \MovieIndex.list)
	var indices: [MovieIndex] = []

	init(identifier: String) {
		self.identifier = identifier
	}
}

@Model
final class MovieIndex {
	var index: Int

	var movie: Movie?
	var list: MovieList?

	init(index: Int) {
		self.index = index
	}
}
