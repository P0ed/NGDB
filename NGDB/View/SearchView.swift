import SwiftUI
import CoreData

struct SearchView: View {
	var list: MovieList

	@State private var query: String = ""
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
		.searchable(text: $query)
		.onDisappear { reset() }
		.onAppear { reset() }
		.onChange(of: query) { _, query in
			list.query = query
			try? list.managedObjectContext?.save()
			if !query.isEmpty {
				Task { try await list.load(using: api) }
			}
		}
	}

	private func reset() {
		list.query = ""
		list.reset(saving: true)
		query = ""
	}
}
