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
				Tab("Discover", systemImage: "list.bullet.circle.fill") {
					DiscoverView(list: .main(in: .main))
				}
				Tab("Account", systemImage: "person.crop.circle.fill") {
					UserView(user: $user, settings: $settings)
				}
			}
        }
		.environment(\.managedObjectContext, .main)
		.environment(\.user, user)
		.environment(\.settings, settings)
		.environment(\.api, .main(apiKey: user.apiKey))
    }
}
