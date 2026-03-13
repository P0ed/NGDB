import SwiftUI
import SwiftData

@main
struct NGDBApp: App {
	var modelContainer: ModelContainer = .movies

	@UserDefault(default: User())
	var user: User

    var body: some Scene {
        WindowGroup {
			DiscoverView(list: .main(in: modelContainer.mainContext))
        }
        .modelContainer(modelContainer)
		.environment(\.user, user)
    }
}
