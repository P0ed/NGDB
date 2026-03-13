import SwiftUI

struct InfiniteList<Items: RandomAccessCollection, Content: View>: View where Items.Element: Identifiable {
	let items: Items
	let loadMore: () async throws -> Void
	let content: (Items.Element) -> Content

	var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(items) { item in
					content(item)
						.onAppear {
							if item.id == items.last?.id {
								Task { try await loadMore() }
							}
						}
				}
			}
		}
		.onAppear {
			if items.isEmpty {
				Task { try await loadMore() }
			}
		}
	}
}
