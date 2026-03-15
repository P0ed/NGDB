import Foundation

/// Private DSL to reduce boilerplate
private func / (lhs: URL, rhs: String) -> URL {
	lhs.appendingPathComponent(rhs)
}

extension URL {

	static var base: URL { URL(string: "https://api.themoviedb.org/3")! }
	static var images: URL { URL(string: "https://image.tmdb.org/t/p/w500")! }

	static var discover: URL { base / "discover" / "movie" }
	static var search: URL { base / "search" / "movie" }
	static func details(_ id: Int) -> URL { base / "movie" / "\(id)" }
	static func image(path: String) -> URL { images / path }
}

extension URL {

	var queryItems: [URLQueryItem]? {
		get { URLComponents(string: absoluteString)?.queryItems }
		set { modify { $0.queryItems = newValue } }
	}

	mutating func modify(_ f: (inout URLComponents) -> Void) {
		if let cpts = URLComponents(string: absoluteString), let url = NGDB.modifying(cpts, f).url {
			self = url
		}
	}

	func modifying(_ f: (inout URLComponents) -> Void) -> URL {
		NGDB.modifying(self) { $0.modify(f) }
	}

	mutating func appendQueryItems(unique: Bool = false, _ items: [URLQueryItem]) {
		if unique {
			queryItems = queryItems?.filter { items[$0.name] == nil }
		}
		queryItems.append(items)
	}
}

extension [URLQueryItem]? {
	mutating func append(_ query: URLQueryItem) {
		self = (self ?? []) + [query]
	}
	mutating func append(_ query: [URLQueryItem]) {
		self = (self ?? []) + query
	}
}

extension [URLQueryItem] {
	subscript(name: String) -> String? { first { $0.name == name }?.value }
}
