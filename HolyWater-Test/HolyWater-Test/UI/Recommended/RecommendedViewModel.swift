//
//  RecommendedViewModel.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 23.02.2024.
//

import Foundation
import RxSwift

class RecommendedViewModel {
    func fetchData() -> Observable<[Carousel]> {
        guard let path = Bundle.main.path(forResource: "json_data", ofType: "json") else {
            return Observable.just([])
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            guard let booksArray = json?["details_carousel"] as? [[String: Any]] else {
                print("Error: Unable to extract 'books' array from JSON")
                return Observable.just([])
            }
            
            let books = try decoder.decode([Carousel].self, from: JSONSerialization.data(withJSONObject: booksArray))
            
            return Observable.just(books)
        } catch {
            print("Error decoding JSON: \(error)")
            return Observable.just([])
        }
    }
    
    func fetchLikedBooksData() -> Observable<[Book]> {
        guard let path = Bundle.main.path(forResource: "json_data", ofType: "json") else {
            return Observable.just([])
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            guard let booksArray = json?["books"] as? [[String: Any]] else {
                print("Error: Unable to extract 'books' array from JSON")
                return Observable.just([])
            }
            
            let books = try decoder.decode([Book].self, from: JSONSerialization.data(withJSONObject: booksArray))
            
            guard let youWillAlsoLikeArray = json?["you_will_like_section"] as? [Int] else {
                print("Error: Unable to extract 'you_will_like_section' array from JSON")
                return Observable.just([])
            }
            
            let recommendedBooks = books.filter { youWillAlsoLikeArray.contains($0.id) }
            
            return Observable.just(recommendedBooks)
        } catch {
            print("Error decoding JSON: \(error)")
            return Observable.just([])
        }
    }
}
