import SwiftUI
import CoreData

struct MovieView: View {
	@ObservedObject var movie: Movie

	@Environment(\.api) var api
	@Environment(\.settings) var settings

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 24.0) {
				poster
				overview
				released
				genres
			}
			.padding()
		}
		.navigationTitle(movie.title ?? "#\(movie.uid)")
		.toolbar { star }
		.task { [api, movie = movie.ref] in
			try? await movie.deref(in: .main).load(using: api)
		}
	}

	@ToolbarContentBuilder
	private var star: some ToolbarContent {
		ToolbarItem(placement: .topBarTrailing) {
			if movie.isFavourite {
				Button("Remove from favourites", systemImage: "star.fill") {
					movie.isFavourite = false
					try? movie.managedObjectContext?.save()
				}
			} else {
				Button("Add to favourites", systemImage: "star") {
					movie.isFavourite = true
					try? movie.managedObjectContext?.save()
				}
			}
		}
	}

	@ViewBuilder
	private var poster: some View {
		if let url = movie.posterURL, settings.loadImages {
			LazyImage(url: url) { image in
				image.resizable().scaledToFit()
			}
		}
	}

	@ViewBuilder
	private var overview: some View {
		if let text = movie.overview {
			Text(text).multilineTextAlignment(.leading)
		}
	}

	@ViewBuilder
	private var released: some View {
		if let date = movie.releaseDate {
			VStack(alignment: .leading) {
				Text("Released:")
					.font(.headline)
				Text(date)
			}
		}
	}

	@ViewBuilder
	private var genres: some View {
		let genres = movie.typedGenres
		if !genres.isEmpty {
			VStack(alignment: .leading) {
				Text("Genres:")
					.font(.headline)
				Text(genres.compactMap(\.name).joined(separator: ", "))
					.multilineTextAlignment(.leading)
			}
		}
	}
}
