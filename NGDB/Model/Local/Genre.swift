import CoreData

extension Genre {

	static func findOrCreate(id: Int, in context: NSManagedObjectContext) -> Genre {
		if let genre = Genre.find(.equals(\Genre.id, Int64(id)), in: context) {
			return genre
		} else {
			let genre = Genre(context: context)
			genre.id = Int64(id)
			return genre
		}
	}

	static func findOrCreate(_ remote: API.Genre, in context: NSManagedObjectContext) -> Genre {
		let genre = Genre.findOrCreate(id: remote.id, in: context)
		genre.name = remote.name
		return genre
	}
}
