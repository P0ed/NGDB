import CoreData

extension NSPredicate {

	var not: NSPredicate { NSCompoundPredicate(notPredicateWithSubpredicate: self) }

	static func not(_ predicate: NSPredicate) -> NSPredicate {
		NSCompoundPredicate(notPredicateWithSubpredicate: predicate)
	}

	static func and(_ predicates: [NSPredicate]) -> NSPredicate {
		NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
	}
	static func and(_ predicates: NSPredicate...) -> NSPredicate { .and(predicates) }

	static func or(_ predicates: [NSPredicate]) -> NSPredicate {
		NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
	}
	static func or(_ predicates: NSPredicate...) -> NSPredicate { .or(predicates) }

	static func equals<Root: NSManagedObject, Value: CoreDataValueConvertible>(_ path: KeyPath<Root, Value>, _ value: Value) -> NSPredicate {
		NSPredicate(format: "%K = %@", argumentArray: [path.stringValue, value.coreDataRepresentation])
	}
	static func notEquals<Root: NSManagedObject, Value: CoreDataValueConvertible>(_ path: KeyPath<Root, Value>, _ value: Value) -> NSPredicate {
		NSPredicate(format: "%K != %@", argumentArray: [path.stringValue, value.coreDataRepresentation])
	}
	static func equals<Root: NSManagedObject, Value: NSObject>(_ path: KeyPath<Root, Value>, _ value: Value) -> NSPredicate {
		NSPredicate(format: "%K = %@", argumentArray: [path.stringValue, value])
	}
	static func notEquals<Root: NSManagedObject, Value: NSObject>(_ path: KeyPath<Root, Value>, _ value: Value) -> NSPredicate {
		NSPredicate(format: "%K != %@", argumentArray: [path.stringValue, value])
	}
	static func isNil<Root: NSManagedObject, Value: OptionalProtocol>(_ path: KeyPath<Root, Value>) -> NSPredicate {
		NSPredicate(format: "%K == nil", argumentArray: [path.stringValue])
	}
	static func notNil<Root: NSManagedObject, Value: OptionalProtocol>(_ path: KeyPath<Root, Value>) -> NSPredicate {
		NSPredicate(format: "%K != nil", argumentArray: [path.stringValue])
	}
	static func contains<Root: NSManagedObject, Value: CoreDataValueConvertible>(caseSensitive: Bool = true, _ path: KeyPath<Root, Value>, _ value: Value) -> NSPredicate {
		NSPredicate(format: "%K CONTAINS\(caseSensitive ? "" : "[cd]") %@", argumentArray: [path.stringValue, value.coreDataRepresentation])
	}
	static func notContains<Root: NSManagedObject, Value: CoreDataValueConvertible>(caseSensitive: Bool = true, _ path: KeyPath<Root, Value>, _ value: Value) -> NSPredicate {
		NSPredicate(format: "NOT (%K CONTAINS\(caseSensitive ? "" : "[cd]") %@)", argumentArray: [path.stringValue, value.coreDataRepresentation])
	}

	static var `true`: NSPredicate { NSPredicate(value: true) }
	static var `false`: NSPredicate { NSPredicate(value: false) }
}

extension KeyPath where Root: NSObject {
	var stringValue: String { NSExpression(forKeyPath: self).keyPath }
}

protocol CoreDataValueConvertible {
	associatedtype CoreDataRepresentation: NSObject
	var coreDataRepresentation: CoreDataRepresentation { get }
}

extension Bool: CoreDataValueConvertible {
	var coreDataRepresentation: NSNumber { self as NSNumber }
}
extension Int16: CoreDataValueConvertible {
	var coreDataRepresentation: NSNumber { self as NSNumber }
}
extension Int32: CoreDataValueConvertible {
	var coreDataRepresentation: NSNumber { self as NSNumber }
}
extension Int64: CoreDataValueConvertible {
	var coreDataRepresentation: NSNumber { self as NSNumber }
}
extension Double: CoreDataValueConvertible {
	var coreDataRepresentation: NSNumber { self as NSNumber }
}
extension String: CoreDataValueConvertible {
	var coreDataRepresentation: NSString { self as NSString }
}
extension Optional: CoreDataValueConvertible where Wrapped: CoreDataValueConvertible {
	var coreDataRepresentation: Wrapped.CoreDataRepresentation {
		map(\.coreDataRepresentation) ?? Wrapped.CoreDataRepresentation()
	}
}
extension NSManagedObject: CoreDataValueConvertible {
	var coreDataRepresentation: NSManagedObjectID { objectID }
}
