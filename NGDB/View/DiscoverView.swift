import SwiftUI
import CoreData

struct DiscoverView: View {
	@ObservedObject var list: MovieList

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
		.onAppear {
			if list.isOutdated, !list.isEmpty {
				list.reset(saving: true)
				pagination.run()
			}
		}
	}
}
