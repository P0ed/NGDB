import CoreData
import Foundation

extension MovieList {

	static func main(in context: NSManagedObjectContext) -> MovieList {
		findOrCreate("mian", in: context)
	}

	static func findOrCreate(_ uid: String, in context: NSManagedObjectContext) -> MovieList {
		let list = MovieList.find(.equals(\MovieList.uid, uid), in: context)

		if let list {
			return list
		} else {
			let list = MovieList(context: context)
			list.uid = uid
			return list
		}
	}

	func reset() {
		page = 0
		isComplete = false
		updatedAt = .distantPast
		indices = []
	}

	@MainActor
	func load() async throws {
		guard !isComplete else { return }

		page += 1
		let response = try await api.discover(Int(page))
		try fill(response)
		try managedObjectContext?.save()
	}

	private func fill(_ remote: API.Discover) throws {
		updatedAt = .now
	}
}
