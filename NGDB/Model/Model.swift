import Foundation
import SwiftData

@Model
final class Movie {
	@Attribute(.unique)
	var identifier: String
    var title: String

	@Relationship(deleteRule: .nullify, inverse: \MovieIndex.movie)
	var indices: [MovieIndex] = []

	init(identifier: String, title: String) {
		self.identifier = identifier
		self.title = title
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
