//
//  ImageCache.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 12..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class ImageCache {

    private let cache = NSCache<NSString, NSObject>()
    private lazy var cacheDirectory: URL = {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }()

    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
        let imageURL = imageURLForKey(key: key)
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            try? data.write(to: imageURL, options: .atomicWrite)
        }
    }

    func imageForKey(key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: NSString(string: key)) as? UIImage {
            return existingImage
        }
        let imageURL = imageURLForKey(key: key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path) else {
            return nil
        }
        cache.setObject(imageFromDisk, forKey: NSString(string: key))
        return imageFromDisk
    }

    func imageURLForKey(key: String) -> URL {
        return cacheDirectory.appendingPathComponent(key)
    }

    func deleteImageForkeys(keys: [String]?) {
        guard let imageKeys = keys else { return }
        imageKeys.forEach {
            cache.removeObject(forKey: NSString(string: $0))
            let imageURL = imageURLForKey(key: $0)
            try? FileManager.default.removeItem(at: imageURL)
        }
    }
}
