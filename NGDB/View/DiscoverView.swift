import SwiftUI
import CoreData

struct DiscoverView: View {
	var list: MovieList

	@State var selected: Movie?
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
		NavigationStack {
			if user.apiKey != .none {
				PaginatedList(
					items: indices.compactMap(\.movie),
					selected: $selected,
					loadMore: { [list = list.ref] in
						try await list.deref(in: .main).load(using: api)
					},
					content: { movie in
						NavigationLink(value: movie) {
							MovieCell(movie: movie)
						}
					}
				)
				.navigationDestination(for: Movie.self) { movie in
					MovieView(movie: movie)
				}
			} else {
				Text("Movies will appear here after providing the API key")
			}
		}
	}
}
