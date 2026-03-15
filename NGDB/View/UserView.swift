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
							.padding(.vertical)
						Toggle("Low data mode", isOn: $settings.lowDataMode)
							.padding(.vertical)
					}
				}
				.padding()
			}
			.toolbar { toolbar }
			.alert(
				"Sign in",
				isPresented: $signInPresented,
				actions: {
					TextField("API key", text: $apiKey)
					Button("Set", role: .confirm) { user.apiKey = apiKey }
					Button("Cancel", role: .cancel) {}
				}
			)
		}
	}

	func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
		Group {
			Text(title)
				.font(.title)
				.padding(.top)
			content()
		}
	}

	@ToolbarContentBuilder
	var toolbar: some ToolbarContent {
		if user.apiKey != .none {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Sign out", systemImage: "door.left.hand.open") {
					user = User()
					PersistenceController.shared.reset()
				}
			}
		} else {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Sign in", systemImage: "door.left.hand.closed") {
					apiKey = ""
					signInPresented = true
				}
			}
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
		.padding(.vertical)
	}
}

private extension String {

	var masked: String {
		"\(prefix(4))********\(suffix(4))"
	}
}
