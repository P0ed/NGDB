import SwiftUI

struct PaginatedList<Items: RandomAccessCollection, Content: View>: View
where Items.Element: Identifiable {
	var items: Items
	@Binding var selected: Items.Element?
	var loadMore: () async throws -> Void
	var content: (Items.Element) -> Content

	@Environment(\.settings) var settings

	var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(items) { item in
					content(item)
						.onAppear {
							if !settings.lowDataMode, item.id == items.last?.id {
								Task { try await loadMore() }
							}
						}
						.onTapGesture {
							selected = item
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
