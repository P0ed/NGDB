// This type allows mapping of FetchedResults without allocation of a new array
struct MappedRandomAccessCollection<Base: RandomAccessCollection, Element>: RandomAccessCollection {
	var base: Base
	var transform: (Base.Element) -> Element

	var startIndex: Base.Index { base.startIndex }
	var endIndex: Base.Index { base.endIndex }

	func index(after i: Base.Index) -> Base.Index {
		base.index(after: i)
	}

	func index(before i: Base.Index) -> Base.Index {
		base.index(before: i)
	}

	subscript(position: Base.Index) -> Element {
		transform(base[position])
	}
}

extension RandomAccessCollection {

	func randomAccessMap<Mapped>(
		_ transform: @escaping (Element) -> Mapped
	) -> MappedRandomAccessCollection<Self, Mapped> {
		.init(base: self, transform: transform)
	}
}
