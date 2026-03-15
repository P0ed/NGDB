import SwiftUI

extension EnvironmentValues {
	@Entry var user: User = User()
	@Entry var settings: Settings = Settings()
	@Entry var api: API = API.main(apiKey: .none)
}
