import SwiftUI

struct UserView: View {
	@Binding var user: User
	@Binding var settings: Settings

	@State var signInPresented: Bool = false

	@State var apiKey: String = ""

	var body: some View {
		if let key = user.apiKey {
			Text("Your API key:")
			Text(key)
		} else {
			Button("Sign in") {
				signInPresented = true
				apiKey = ""
			}
			.alert(
				"Sign in",
				isPresented: $signInPresented,
				actions: {
					TextField("API key", text: $apiKey)
					Button("Set", role: .confirm) {
						user.apiKey = apiKey
					}
					Button("Cancel", role: .cancel) {}
				}
			)
		}
	}
}
