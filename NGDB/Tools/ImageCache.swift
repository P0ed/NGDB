import UIKit

actor ImageCache {
	static let shared = ImageCache()

	private var cache: NSCache<NSURL, UIImage> = with(.init()) {
		$0.countLimit = 64
	}

	func cached(for key: URL) -> UIImage? {
		cache.object(forKey: key as NSURL)
	}

	func cache(_ image: UIImage, for key: URL) {
		cache.setObject(image, forKey: key as NSURL)
	}
}
