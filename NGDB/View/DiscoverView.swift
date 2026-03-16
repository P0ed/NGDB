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
		NavigationStack {
			if user.apiKey != .none {
				InfiniteList(
					items: indices.randomAccessMap { $0.movie ?? Movie() },
					shouldLoad: { !list.isComplete },
					load: { try await list.load(using: api) },
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
			if list.isOutdated {
				list.reset(saving: true)
				Task { try await list.load(using: api) }
			}
		}
	}
}
