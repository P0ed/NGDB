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
			DiscoverView(list: .main(in: .main))
        }
		.environment(\.managedObjectContext, .main)
		.environment(\.user, user)
		.environment(\.settings, settings)
    }
}
