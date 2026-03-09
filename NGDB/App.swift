import SwiftUI
import SwiftData

@main
struct NGDBApp: App {
	var sharedModelContainer: ModelContainer = .movies

	@AppStorage(wrappedValue: "", "APIKey")
	var apiKey: String

    var body: some Scene {
        WindowGroup {
			ContentView(list: .init(identifier: "main"))
        }
        .modelContainer(sharedModelContainer)
    }
}
