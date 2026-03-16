import SwiftUI

struct InfiniteList<Items: RandomAccessCollection, Content: View>: View
where Items.Element: Identifiable {
	var items: Items
	var pagination: LoadAction?
	var content: (Items.Element) -> Content

	@State private var isLoading: Bool = false

	var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(items) { item in
					content(item)
						.onAppear {
							if item.id == items.last?.id {
								pagination?.run()
							}
						}
				}
			}
			footer
		}
		.onAppear {
			if items.isEmpty { pagination?.run() }
		}
	}

	@ViewBuilder
	private var footer: some View {
		if let pagination, pagination.isLoading {
			ProgressView().padding(.vertical, .m)
		}
	}
}
