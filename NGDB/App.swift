import SwiftUI
import CoreData

@main
struct NGDBApp: App {
	var persistenceController: PersistenceController = .shared

	@UserDefault(default: User())
	var user: User

	@UserDefault(default: Settings())
	var settings: Settings

    var body: some Scene {
        WindowGroup {
			TabView {
				Tab("Discover", systemImage: "list.bullet.circle") {
					DiscoverView(list: .discover(in: .main))
				}
				Tab("Account", systemImage: "person.crop.circle") {
					UserView(user: $user, settings: $settings)
				}
				Tab(role: .search) {
					SearchView(list: .search(in: .main))
				}
			}
			.tint(.primary)
        }
		.environment(\.managedObjectContext, .main)
		.environment(\.user, user)
		.environment(\.settings, settings)
		.environment(\.api, .main(apiKey: user.apiKey))
    }
}
