import SwiftUI
import CoreData

struct MovieCell: View {
	var movie: Movie

	@Environment(\.settings) var settings

	var body: some View {
		HStack {
			if settings.loadImages, let url = movie.posterURL {
				AsyncImage(url: url) { result in
					result.image?
						.resizable()
						.scaledToFill()
				}
				.frame(maxWidth: 64.0)
			}
			Text(movie.title ?? "")
			Spacer()
		}
		.padding()
	}
}
