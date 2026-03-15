import SwiftUI
import CoreData

struct SearchView: View {
	var list: MovieList

	@State var query: String = ""
	@Environment(\.managedObjectContext) private var modelContext
	@Environment(\.user) private var user
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
					loadMore: { [list = list.ref] in
						try await list.deref(in: .main).load(using: api)
					},
					content: { movie in
						NavigationLink(value: movie) {
							MovieCell(movie: movie)
						}
						.buttonStyle(PlainButtonStyle())
					}
				)
				.navigationDestination(for: Movie.self) { movie in
					MovieView(movie: movie)
				}
			} else {
				UnauthorizedPlaceholder()
			}
		}
		.searchable(text: $query)
		.onDisappear {
			query = ""
			list.reset(saving: true)
		}
		.onChange(of: query) { oldValue, newValue in
			list.query = newValue
			try? list.managedObjectContext?.save()
			Task { try await list.load(using: api) }
		}
	}
}
