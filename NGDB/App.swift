import SwiftUI
import CoreData

@main
struct NGDBApp: App {
	var modelContainer: NSPersistentContainer = .shared

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
				Tab("Favourites", systemImage: "star") {
					FavouritesView()
				}
				Tab("Account", systemImage: "person.crop.circle") {
					UserView(user: $user, settings: $settings)
				}
				Tab(role: .search) {
					SearchView(list: .search(in: .main))
				}
			}
			.tint(.secondary)
        }
		.environment(\.modelContainer, modelContainer)
		.environment(\.managedObjectContext, modelContainer.viewContext)
		.environment(\.user, user)
		.environment(\.settings, settings)
		.environment(\.api, .main(apiKey: user.apiKey))
    }
}
