import SwiftUI

struct UserView: View {
	@Binding var user: User
	@Binding var settings: Settings

	@State var signInPresented: Bool = false
	@State var apiKey: String = ""

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading) {
					section("User") {
						userInfo
					}
					Divider()
					section("Settings") {
						Toggle("Load images", isOn: $settings.loadImages)
						Toggle("Low data mode", isOn: $settings.lowDataMode)
					}
				}
				.padding()
			}
			.toolbar {
				if user.apiKey != .none {
					ToolbarItem(placement: .topBarTrailing) {
						Button("Sign out", systemImage: "door.left.hand.open") {
							user = User()
						}
					}
				} else {
					ToolbarItem(placement: .topBarTrailing) {
						Button("Sign in", systemImage: "door.left.hand.closed") {
							signInPresented = true
							apiKey = ""
						}
					}
				}
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

	func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
		Group {
			Text(title)
				.font(.headline)
			content()
		}
	}

	var userInfo: some View {
		HStack {
			Text("API key:")
			Spacer()
			if let key = user.apiKey {
				Button(key.masked) {
					UIPasteboard.general.string = key
				}
			} else {
				Text("<none>")
			}
		}
	}
}

private extension String {

	var masked: String {
		"\(prefix(4))********\(suffix(4))"
	}
}
