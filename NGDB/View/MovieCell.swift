import SwiftUI
import CoreData

struct MovieCell: View {
	var movie: Movie

	@Environment(\.settings) var settings

	var body: some View {
		HStack {
			if settings.loadImages {
//				Image(url: "")
			}
			Text(movie.title ?? "")
			Spacer()
		}
		.padding()
	}
}
