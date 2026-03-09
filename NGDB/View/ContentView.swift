import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

	@Query(
		filter: #Predicate<MovieIndex> { idx in idx.movie != nil && idx.list?.identifier == "main" },
		sort: [.init(\.index, order: .forward)],
		animation: .default
	)
	private var indices: [MovieIndex]

    var body: some View {
        NavigationSplitView {
            List {
				ForEach(indices.compactMap(\.movie)) { item in
                    NavigationLink {
						Text(item.title)
                    } label: {
						Text(item.title)
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
}
