import SwiftUI
import CoreData

struct DiscoverView: View {
	var list: MovieList

	@Environment(\.managedObjectContext) private var modelContext
	@Environment(\.user) private var user
	@Environment(\.settings) private var settings
	@FetchRequest private var indices: FetchedResults<MovieIndex>

	init(list: MovieList) {
		self.list = list

		_indices = FetchRequest(
			sortDescriptors: [.init(keyPath: \MovieIndex.index, ascending: true)],
			predicate: .equals(\.objectID, list.objectID),
			animation: .default
		)
	}

	var body: some View {
		NavigationSplitView {
			InfiniteList(
				items: indices.compactMap(\.movie),
				loadMore: { [list = list.ref] in try await list.onMain.load() },
				content: MovieCell.init
			)
		} detail: {
			Text("Select a movie")
		}
	}
}
