import SwiftUI
import CoreData

struct DiscoverView: View {
	var list: MovieList

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
					// TODO: Remove compactMap as it defeats the purpose of indices being random access collection
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
		.onAppear {
			if list.isOutdated {
				list.reset()
				try? list.managedObjectContext?.save()
				Task { try await list.load(using: api) }
			}
		}
	}
}
