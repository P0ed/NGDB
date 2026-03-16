import SwiftUI

@MainActor
struct LoadAction {
	private var load: () async throws -> Void
	private var shouldLoad: () -> Bool

	init(load: @escaping () async throws -> Void, shouldLoad: @escaping () -> Bool) {
		self.load = load
		self.shouldLoad = shouldLoad
	}

	@State var isLoading: Bool = false

	func run() {
		guard !isLoading, shouldLoad() else { return }
		isLoading = true
		Task {
			defer { isLoading = false }
			try await load()
		}
	}
}

extension LoadAction {

	init(paginated list: MovieList, api: API) {
		self = LoadAction(
			load: {
				try await list.load(using: api)
			},
			shouldLoad: {
				if let query = list.query {
					query != ""
				} else {
					!list.isComplete
				}
			}
		)
	}
}
