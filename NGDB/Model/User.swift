import SwiftUI

struct User: Codable {
	var apiKey: String?
}

struct Settings: Codable {
	var loadImages: Bool = true
	var lowDataMode: Bool = false
}

extension EnvironmentValues {
	@Entry var user: User = User()
	@Entry var settings: Settings = Settings()
}
