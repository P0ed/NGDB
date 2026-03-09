struct UnexpectedNilValueError: Error {
	var type: Any.Type
}

func unwrap<A>(_ value: A?) throws -> A {
	try value ?? { throw UnexpectedNilValueError(type: A.self) }()
}

struct CastError: Error {
	var from: Any.Type
	var to: Any.Type
}

func cast<A, B>(_ value: A) throws -> B {
	try (value as? B) ?? { throw CastError(from: type(of: value), to: B.self) }()
}
