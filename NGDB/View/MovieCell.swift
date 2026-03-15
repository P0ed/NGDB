import SwiftUI
import CoreData

struct MovieCell: View {
	var movie: Movie

	@Environment(\.settings) var settings

	var body: some View {
		HStack(alignment: .center) {
			if settings.loadImages, let url = movie.posterURL {
				AsyncImage(url: url, transaction: .init(animation: .easeInOut)) { phase in
					phase.image?
						.resizable()
						.scaledToFit()
				}
				.frame(width: 88.0)
			}
			VStack(alignment: .leading) {
				Text(movie.title ?? "")
					.font(.headline)
					.multilineTextAlignment(.leading)
					.padding(.bottom, 8.0)
				Text(movie.overview ?? "")
					.font(.footnote)
					.multilineTextAlignment(.leading)
				Spacer(minLength: 0)
			}
			Spacer()
		}
		.frame(height: 128.0)
		.padding(.horizontal, 12.0)
		.padding(.vertical, 4.0)
	}
}
