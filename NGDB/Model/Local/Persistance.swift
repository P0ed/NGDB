import CoreData

struct PersistenceController {
	static let shared = PersistenceController()

	let container: NSPersistentContainer

	init(inMemory: Bool = false) {
		container = NSPersistentContainer(name: "Model")
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		container.viewContext.automaticallyMergesChangesFromParent = true
	}

	@MainActor
	func reset() {
		let ctx = NSManagedObjectContext.main
		MovieList.discover(in: ctx).reset()
		Movie.fetch(in: ctx).forEach(ctx.delete)
		try? ctx.save()
	}
}

@MainActor
extension NSManagedObjectContext {

	static var main: NSManagedObjectContext {
		PersistenceController.shared.container.viewContext
	}
}

func performBackgroundTask(
	_ body: @Sendable @escaping (NSManagedObjectContext) throws -> Void
) async throws {
	let container = PersistenceController.shared.container

	try await withCheckedThrowingContinuation { continuation in
		container.performBackgroundTask { context in
			do {
				try body(context)
				continuation.resume()
			} catch {
				continuation.resume(throwing: error)
			}
		}
	}
}
