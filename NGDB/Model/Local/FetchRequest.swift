import SwiftUI
import CoreData

extension FetchRequest {

	static func movies(_ list: MovieList) -> FetchRequest<MovieIndex> {
		.init(
			sortDescriptors: [.init(keyPath: \MovieIndex.index, ascending: true)],
			predicate: .and(
				.equals(\MovieIndex.list, list),
				.notNil(\MovieIndex.movie)
			),
			animation: .default
		)
	}
}
