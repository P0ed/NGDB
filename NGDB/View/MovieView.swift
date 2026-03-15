import SwiftUI
import CoreData

struct MovieView: View {
	@ObservedObject var movie: Movie

	@Environment(\.api) var api

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 24.0) {
				if let url = movie.posterURL {
					AsyncImage(url: url) { phase in
						phase.image?
							.resizable()
							.scaledToFit()
					}
				}

				if let text = movie.overview {
					Text(text)
						.multilineTextAlignment(.leading)
				}
			}
			.padding()
		}
		.navigationTitle(movie.title ?? "#\(movie.uid)")
		.toolbar {
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
		.task { [api, movie = movie.ref] in
			try? await movie.deref(in: .main).load(using: api)
		}
	}
}
