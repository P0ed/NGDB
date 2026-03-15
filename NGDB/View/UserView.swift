import SwiftUI

struct UserView: View {
	@Binding var user: User
	@Binding var settings: Settings

	@State var signInPresented: Bool = false
	@State var apiKey: String = ""
	@State var copied: Bool = false

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading) {
					section("User") {
						userInfo
					}
					section("Settings") {
						Toggle("Load images", isOn: $settings.loadImages)
							.padding(.vertical, 4.0)
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
					signOut()
				}
			}
		} else {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Sign in", systemImage: "door.left.hand.closed") {
					signIn()
				}
			}
		}
	}

	var userInfo: some View {
		HStack {
			Text("API key:")
			Spacer()
			if copied {
				Text("Copied to pasteboard")
			} else if let key = user.apiKey {
				Button(key.masked) {
					UIPasteboard.general.string = key
					copied = true
					Task {
						try await Task.sleep(for: .seconds(1))
						copied = false
					}
				}
			} else {
				Button("<none>") {
					signIn()
				}
			}
		}
		.padding(.vertical)
	}

	func signIn() {
		apiKey = ""
		signInPresented = true
	}

	func signOut() {
		user.apiKey = .none
		PersistenceController.shared.reset()
	}
}

private extension String {

	var masked: String {
		"\(prefix(4))••••••••\(suffix(4))"
	}
}
