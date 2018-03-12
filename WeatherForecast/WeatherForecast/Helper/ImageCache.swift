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

    // 이미지 추가
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
        let imageURL = imageURLForKey(key: key)
        // 압축 품질
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            try? data.write(to: imageURL, options: .atomicWrite)
        }
    }

    // 이미지 꺼내오기
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

    // 주어진 키를 이용해 다큐먼트 디렉터리에 URL을 만든다.
    func imageURLForKey(key: String) -> URL {
        return cacheDirectory.appendingPathComponent(key)
    }

    // 이미지 삭제
    func deleteImageForkeys(keys: [String]?) {
        guard let imageKeys = keys else { return }
        imageKeys.forEach {
            cache.removeObject(forKey: NSString(string: $0))
            let imageURL = imageURLForKey(key: $0)
            try? FileManager.default.removeItem(at: imageURL)
        }
    }
}
