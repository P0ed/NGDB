import SwiftUI
import SwiftData

struct DiscoverView: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.user) private var user

	var list: MovieList

	@Query private var indices: [MovieIndex]
	private var movies: [Movie] { indices.compactMap(\.movie) }

	init(list: MovieList) {
		self.list = list

		let id = list.identifier
		_indices = Query(
			filter: #Predicate<MovieIndex> { idx in
				idx.movie != nil && idx.list?.identifier == id
			},
			sort: [.init(\.index, order: .forward)]
		)
	}

    var body: some View {
		NavigationSplitView {
			InfiniteList(
				items: movies,
				loadMore: { try await list.load() },
				content: { item in Text(item.title) }
			)
		} detail: {
			Text("Select an item")
		}
    }
}
