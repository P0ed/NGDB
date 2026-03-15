import SwiftUI
import CoreData

struct MovieCell: View {
	var movie: Movie

	var body: some View {
		Text(movie.title ?? "")
	}
}
