import SwiftUI

struct LazyImage<Content: View>: View {
	var url: URL
	var placeholder: Image = Image(.clear)
	var content: (Image) -> Content

	@State private var image: Image?
	@State private var task: Task<Void, Error>?

	var body: some View {
		ZStack {
			if let image {
				content(image).transition(.opacity)
			} else {
				content(placeholder)
			}
		}
		.onAppear { load() }
		.onDisappear { task?.cancel() }
	}

	func load() {
		task?.cancel()
		task = Task {
			if let cached = await ImageCache.shared.cached(for: url) {
				await MainActor.run { image = Image(uiImage: cached) }
			} else {
				let (data, _) = try await URLSession.shared.data(from: url)
				let img = try unwrap(UIImage(data: data))
				await ImageCache.shared.cache(img, for: url)
				await MainActor.run {
					withAnimation {
						image = Image(uiImage: img)
					}
				}
			}
		}
	}
}
