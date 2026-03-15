import SwiftUI

struct MovieView: View {
	var movie: Movie

	@Environment(\.api) var api

	var body: some View {
		ScrollView {
			VStack {
				if let url = movie.posterURL {
					AsyncImage(url: url) { result in
						result.image?
							.resizable()
							.scaledToFill()
					}
				}

				if let text = movie.overview {
					Text(text)
				}
			}
			.padding()
		}
		.navigationTitle(movie.title ?? "#\(movie.uid)")
		.task { @MainActor [api, movie = movie.ref] in
			try? await movie.onMain.load(using: api)
		}
//		.onAppear { [api] in
//			Task {
//				try await { @MainActor in  }()
//			}
//		}
	}
}
