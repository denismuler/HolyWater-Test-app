//
//  BookViewModel.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 21.02.2024.
//

import Foundation

class LibraryViewModel {
    private let remoteConfigManager = FirebaseRemoteConfigManager.shared
    public var books: [Book] = []
    public var banners: [Banner] = []

    func fetchRemoteConfig(completion: @escaping (Error?) -> Void) {
        remoteConfigManager.fetchRemoteConfig { [weak self] error in
            if let error = error {
                completion(error)
            } else {
                self?.updateBooks()
                self?.updateBanners()
                completion(nil)
            }
        }
    }

    func getJsonData() -> String {
        return remoteConfigManager.getConfigValue(forKey: "json_data")
    }

    private func updateBooks() {
        if let jsonData = getJsonData().data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                if let jsonDict = jsonObject as? [String: Any],
                   let booksArray = jsonDict["books"] as? [[String: Any]] {
                    self.books = try decoder.decode([Book].self, from: JSONSerialization.data(withJSONObject: booksArray))
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
    
    private func updateBanners() {
        if let jsonData = getJsonData().data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                if let jsonDict = jsonObject as? [String: Any],
                   let bannersArray = jsonDict["top_banner_slides"] as? [[String: Any]] {
                    self.banners = try decoder.decode([Banner].self, from: JSONSerialization.data(withJSONObject: bannersArray))
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
}

