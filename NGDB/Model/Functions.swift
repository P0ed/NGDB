/// Atomically mutates a value
func modify<A>(_ value: inout A, _ body: (inout A) throws -> Void) rethrows {
	var copy = value
	try body(&copy)
	value = copy
}

/// Returns mutated copy of a value
func modifying<A>(_ value: A, _ body: (inout A) throws -> Void) rethrows -> A {
	var copy = value
	try body(&copy)
	return copy
}

/// The with function is useful for applying functions to objects, wrapping imperative configuration in an expression
@_transparent @discardableResult
func with<A>(_ value: A, _ body: (A) throws -> Void) rethrows -> A {
	try body(value)
	return value
}

/// Returns transformed value
func transform<A, B>(_ value: A, _ body: (A) throws -> B) rethrows -> B {
	try body(value)
}
