import SwiftUI

struct MovieView: View {
	var movie: Movie

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
		.task { [api, movie = movie.ref] in
			try? await movie.deref(in: .main).load(using: api)
		}
	}
}
