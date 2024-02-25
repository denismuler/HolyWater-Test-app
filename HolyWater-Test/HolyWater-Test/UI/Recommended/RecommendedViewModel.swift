//
//  RecommendedViewModel.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 23.02.2024.
//

import Foundation

class RecommendedViewModel {
    
    private let remoteConfigManager = FirebaseRemoteConfigManager.shared
    public var carousel: [Carousel] = []
    public var recommended: [Book] = []
    
    func fetchRemoteConfig(completion: @escaping (Error?) -> Void) {
        remoteConfigManager.fetchRemoteConfig { [weak self] error in
            if let error = error {
                completion(error)
            } else {
                self?.updateCarousel()
                self?.updateRecommended()
                completion(nil)
            }
        }
    }

    func getJsonData() -> String {
        return remoteConfigManager.getConfigValue(forKey: "json_data")
    }
    
    func getDetailsCarousel() -> String {
        return remoteConfigManager.getConfigValue(forKey: "details_carousel")
    }

    private func updateCarousel() {
        if let jsonData = getDetailsCarousel().data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                if let jsonDict = jsonObject as? [String: Any],
                   let carouselArray = jsonDict["books"] as? [[String: Any]] {
                    self.carousel = try decoder.decode([Carousel].self, from: JSONSerialization.data(withJSONObject: carouselArray))
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }

    
    private func updateRecommended() {
        if let jsonData = getJsonData().data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                guard let jsonDict = jsonObject as? [String: Any],
                      let booksArray = jsonDict["books"] as? [[String: Any]] else { return }
                let books = try decoder.decode([Book].self, from: JSONSerialization.data(withJSONObject: booksArray))
                
                guard let jsonDict = jsonObject as? [String: Any],
                      let recommendedArray = jsonDict["you_will_like_section"] as? [Int] else { return }
                
                let recommendedBooks = books.filter { recommendedArray.contains($0.id) }
                recommended = recommendedBooks
                   
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
}
