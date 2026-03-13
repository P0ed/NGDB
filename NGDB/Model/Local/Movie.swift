import Foundation
import SwiftData

@Model
final class Movie {
	@Attribute(.unique)
	var identifier: String
    var title: String

	@Relationship(deleteRule: .cascade, inverse: \MovieIndex.movie)
	var indices: [MovieIndex] = []

	init(identifier: String, title: String) {
		self.identifier = identifier
		self.title = title
	}
}
