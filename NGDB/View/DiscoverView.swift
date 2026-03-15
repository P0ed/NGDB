import SwiftUI
import CoreData

struct DiscoverView: View {
	var list: MovieList

	@Environment(\.managedObjectContext) private var modelContext
	@Environment(\.user) private var user
	@Environment(\.settings) private var settings
	@Environment(\.api) private var api
	@FetchRequest private var indices: FetchedResults<MovieIndex>

	init(list: MovieList) {
		self.list = list

		_indices = FetchRequest(
			sortDescriptors: [.init(keyPath: \MovieIndex.index, ascending: true)],
			predicate: .equals(\MovieIndex.list?.uid, list.uid ?? ""),
			animation: .default
		)
	}

	var body: some View {
		if user.apiKey != nil {
			NavigationSplitView {
				PaginatedList(
					items: indices.compactMap(\.movie),
					loadMore: { [list = list.ref] in
						try await list.onMain.load(using: api)
					},
					content: MovieCell.init
				)
			} detail: {
				Text("Select a movie")
			}
		} else {
			Text("Movies will appear here")
		}
	}
}
