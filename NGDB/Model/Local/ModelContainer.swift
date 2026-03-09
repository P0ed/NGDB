import SwiftData

extension ModelContainer {

	static var movies: ModelContainer = {
		let schema = Schema([
			Movie.self,
			MovieIndex.self,
			MovieList.self,
		])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

		do {
			return try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()
}
