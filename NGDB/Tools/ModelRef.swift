import CoreData

struct ModelRef<A: NSManagedObject>: Sendable, Hashable {
	var id: NSManagedObjectID

	func deref(in ctx: NSManagedObjectContext) -> A {
		ctx.object(with: id) as! A
	}
}

protocol ManagedObjectProtocol: NSManagedObject {}

extension NSManagedObject: ManagedObjectProtocol {}

extension ManagedObjectProtocol {
	var ref: ModelRef<Self> { .init(id: objectID) }
}

extension ManagedObjectProtocol {

	static func createRequest(predicate: NSPredicate? = nil, sort: [NSSortDescriptor] = [], limit: Int = 0) -> NSFetchRequest<Self> {
		let request = NSFetchRequest<Self>(entityName: "\(self)")
		request.predicate = predicate
		request.sortDescriptors = sort
		request.fetchLimit = limit
		return request
	}

	static func fetch(_ predicate: NSPredicate? = nil, sort: [NSSortDescriptor] = [], limit: Int = 0, in ctx: NSManagedObjectContext) -> [Self] {
		let request = createRequest(predicate: predicate, sort: sort, limit: limit)
		return fetch(request, in: ctx)
	}

	static func fetch(_ request: NSFetchRequest<Self>, in ctx: NSManagedObjectContext) -> [Self] {
		(try? ctx.fetch(request)) ?? []
	}

	static func find(_ predicate: NSPredicate, in ctx: NSManagedObjectContext, sort: [NSSortDescriptor] = []) -> Self? {
		fetch(predicate, sort: sort, limit: 1, in: ctx).first
	}

	static func count(_ predicate: NSPredicate?, in ctx: NSManagedObjectContext) -> Int {
		(try? ctx.count(for: createRequest(predicate: predicate))) ?? 0
	}
}
