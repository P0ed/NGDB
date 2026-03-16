import SwiftUI

struct List<Items: RandomAccessCollection, Content: View>: View
where Items.Element: Identifiable {
	var items: Items
	var shouldLoad: () -> Bool = { false }
	var load: () async throws -> Void = {}
	var content: (Items.Element) -> Content

	@State var isLoading: Bool = false

	var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(items) { item in
					content(item)
						.onAppear {
							if item.id == items.last?.id {
								loadItems()
							}
						}
				}
			}
			footer
		}
		.onAppear {
			if items.isEmpty { loadItems() }
		}
	}

	@ViewBuilder
	private var footer: some View {
		if isLoading {
			ProgressView().padding(.vertical, .m)
		}
	}

	private func loadItems() {
		guard !isLoading, shouldLoad() else { return }

		isLoading = true
		Task {
			defer { isLoading = false }
			try await load()
		}
	}
}
