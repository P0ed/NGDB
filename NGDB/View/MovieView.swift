import SwiftUI

struct MovieView: View {
	var movie: Movie

	var body: some View {
		ScrollView {
			VStack {
				if let url = movie.posterURL {
					AsyncImage(url: url)
				}

				if let text = movie.overview {
					Text(text)
				}
			}
			.padding()
		}
		.navigationTitle(movie.title ?? "#\(movie.uid)")
	}
}
