import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext

	var list: MovieList

	@Query(
		filter: #Predicate<MovieIndex> { idx in
			idx.movie != nil && idx.list?.identifier == "main"
		},
		sort: [.init(\.index, order: .forward)],
		animation: .default
	)
	private var indices: [MovieIndex]

	private var movies: [Movie] {
		indices.compactMap(\.movie)
	}

    var body: some View {
        NavigationSplitView {
            List {
				ForEach(movies) { item in
                    NavigationLink {
						Text(item.title)
                    } label: {
						Text(item.title)
                    }
                }
            }
			.onAppear {

			}
        } detail: {
            Text("Select an item")
        }
    }
}
