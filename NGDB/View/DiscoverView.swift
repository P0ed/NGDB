import SwiftUI
import CoreData

struct DiscoverView: View {
	var list: MovieList

	@FetchRequest private var indices: FetchedResults<MovieIndex>

	@Environment(\.managedObjectContext) private var modelContext
	@Environment(\.user) private var user
	@Environment(\.api) private var api

	init(list: MovieList) {
		self.list = list
		_indices = .movies(list)
	}

	var body: some View {
		NavigationStack {
			if user.apiKey != .none {
				PaginatedList(
					items: indices.randomAccessMap { $0.movie ?? Movie() },
					load: { [list = list.ref] in
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
				list.reset(saving: true)
				Task { try await list.load(using: api) }
			}
		}
	}
}
