protocol OptionalProtocol {
	associatedtype A

	static func optional(_ value: A?) -> Self
	var optional: A? { get }
}

extension Optional: OptionalProtocol {
	public static func optional(_ value: Optional) -> Optional { value }
	public var optional: Optional { self }
}
