import SwiftUI

struct User: Codable {
	var apiKey: String?
}

extension EnvironmentValues {
	@Entry var user: User = User()
}
