import SwiftUI

struct UserView: View {
	@Binding var user: User
	@Binding var settings: Settings

	@State var signInPresented: Bool = false
	@State var apiKey: String = ""
	@State var copied: Bool = false

	@FetchRequest(sortDescriptors: []) var movies: FetchedResults<Movie>

	@Environment(\.modelContainer) var modelContainer

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading) {
					section("User") {
						userInfo
					}
					section("Settings") {
						Toggle("Load images", isOn: $settings.loadImages)
							.padding(.vertical, .xs)
					}
					section("Data") {
						resetView
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
	private var toolbar: some ToolbarContent {
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

	private var userInfo: some View {
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
		.padding(.vertical, .s)
	}

	@ViewBuilder
	private var resetView: some View {
		if movies.isEmpty {
			Text("Database is empty")
				.padding(.vertical, .xs)
		} else {
			Button("Delete \(movies.count) movies") {
				modelContainer.reset()
			}
			.padding(.vertical, .xs)
		}
	}

	private func signIn() {
		apiKey = ""
		signInPresented = true
	}

	private func signOut() {
		user.apiKey = .none
		modelContainer.reset()
	}
}

private extension String {

	var masked: String {
		"\(prefix(4))••••••••\(suffix(4))"
	}
}
