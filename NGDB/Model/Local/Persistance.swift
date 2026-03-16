import CoreData

extension NSPersistentContainer {

	static let shared: NSPersistentContainer = {
		with(NSPersistentContainer(name: "Model")) { container in

			container.loadPersistentStores(completionHandler: { (storeDescription, error) in
				if let error = error as NSError? {
					fatalError("Unresolved error \(error), \(error.userInfo)")
				}
			})
			container.viewContext.automaticallyMergesChangesFromParent = true
		}
	}()

	@MainActor
	func reset() {
		MovieList.discover(in: viewContext).reset()
		MovieList.search(in: viewContext).reset()
		Movie.fetch(in: viewContext).forEach(viewContext.delete)
		try? viewContext.save()
	}
}

@MainActor
extension NSManagedObjectContext {

	static var main: NSManagedObjectContext {
		NSPersistentContainer.shared.viewContext
	}
}

func performBackgroundTask(
	_ body: @Sendable @escaping (NSManagedObjectContext) throws -> Void
) async throws {
	let container = NSPersistentContainer.shared

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
