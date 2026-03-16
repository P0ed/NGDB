import SwiftUI

struct PaginatedList<Items: RandomAccessCollection, Content: View>: View
where Items.Element: Identifiable {
	var items: Items
	var load: () async throws -> Void
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
			ProgressView().padding(.vertical, 12.0)
		}
	}

	private func loadItems() {
		if isLoading { return }

		isLoading = true
		Task {
			defer { isLoading = false }
			try await load()
		}
	}
}
