import SwiftUI
import CoreData

struct FavouritesView: View {
	@FetchRequest(
		sortDescriptors: [.init(keyPath: \Movie.title, ascending: true)],
		predicate: .equals(\Movie.isFavourite, true)
	)
	private var movies: FetchedResults<Movie>

	@Environment(\.managedObjectContext) private var modelContext
	@Environment(\.user) private var user
	@Environment(\.api) private var api

	var body: some View {
		NavigationStack {
			if movies.isEmpty {
				Text("Favourite movies will appear here")
			} else {
				InfiniteList(
					items: movies,
					content: { movie in MovieCell(movie: movie) }
				)
				.navigationDestination(for: Movie.self) { movie in
					MovieView(movie: movie)
				}
			}
		}
	}
}
