struct User: Codable {
	var apiKey: String?
}

struct Settings: Codable {
	var loadImages: Bool = true
	var lowDataMode: Bool = false
}
