import SwiftUI
import CoreData

struct SearchView: View {
	@ObservedObject var list: MovieList

	@State private var query: String = ""
	@FetchRequest private var indices: FetchedResults<MovieIndex>

	@Environment(\.user) private var user
	@Environment(\.api) private var api

	init(list: MovieList) {
		self.list = list
		_indices = .movies(list)
	}

	var body: some View {
		let pagination = LoadAction(paginated: list, api: api)

		NavigationStack {
			if user.apiKey != .none {
				InfiniteList(
					items: indices.randomAccessMap { $0.movie ?? Movie() },
					pagination: pagination,
					content: { movie in MovieCell(movie: movie) }
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
			pagination.run()
		}
	}

	private func reset() {
		list.query = ""
		list.reset(saving: true)
		query = ""
	}
}
