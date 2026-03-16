import SwiftUI
import CoreData

struct MovieCell: View {
	var movie: Movie

	@Environment(\.settings) var settings

	var body: some View {
		NavigationLink(value: movie) {
			HStack(alignment: .center) {
				if settings.loadImages, let url = movie.posterURL {
					LazyImage(url: url) { image in
						image
							.resizable()
							.scaledToFit()
					}
					.frame(width: 88.0)
				}
				VStack(alignment: .leading) {
					Text(movie.title ?? "")
						.font(.headline)
						.multilineTextAlignment(.leading)
						.padding(.bottom, .s)
					Text(movie.overview ?? "")
						.font(.footnote)
						.multilineTextAlignment(.leading)
					Spacer(minLength: 0)
				}
				Spacer()
			}
			.frame(height: 128.0)
			.padding(.horizontal, .m)
			.padding(.vertical, .xs)
			.contentShape(Rectangle())
		}
		.buttonStyle(PlainButtonStyle())
	}
}
