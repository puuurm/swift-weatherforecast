//
//  StorageManager.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 2..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

final class StorageManager {

    private let fileManager: FileManager
    private let baseURL: URL?

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        baseURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    func setObject<T: Codable>(_ object: T, forKey key: String) {
        guard let objectURL = url(key: key) else { return }
        let encoder = PropertyListEncoder()
        var data = Data()
        do {
            data = try encoder.encode(History.shared)
        } catch {
            print(error.localizedDescription)
        }
        try? data.write(to: objectURL, options: .atomicWrite)
    }

    func object<T: Codable>(ofType type: T.Type, forKey key: String) -> T? {
        guard let objectURL = url(key: key) else {
            return nil
        }
        let decoder = PropertyListDecoder()
        var data = Data()
        do {
            data = try Data(contentsOf: objectURL, options: .mappedIfSafe)
        } catch {
            print(error.localizedDescription)
        }
        do {
            let object = try decoder.decode(type.self, from: data)
            return object
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    private func url(key: String) -> URL? {
        return baseURL?.appendingPathComponent(key)
    }

    func deleteObject(forKey key: String) {
        guard let url = url(key: key) else { return }
        try? fileManager.removeItem(at: url)
    }

}
