//
//  BookViewModel.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 21.02.2024.
//

import Foundation
import RxDataSources
import RxSwift

class BooksViewModel {
    private let disposeBag = DisposeBag()

    func fetchData() -> Observable<(books: [Book], topBannerSlides: [Banner])> {
        guard let path = Bundle.main.path(forResource: "json_data", ofType: "json") else {
            return Observable.just((books: [], topBannerSlides: []))
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            guard let booksArray = json?["books"] as? [[String: Any]] else {
                print("Error: Unable to extract 'books' array from JSON")
                return Observable.just((books: [], topBannerSlides: []))
            }

            let books = try decoder.decode([Book].self, from: JSONSerialization.data(withJSONObject: booksArray))

            guard let topBannerSlidesArray = json?["top_banner_slides"] as? [[String: Any]] else {
                print("Error: Unable to extract 'top_banner_slides' array from JSON")
                return Observable.just((books: books, topBannerSlides: []))
            }

            let topBannerSlides = try decoder.decode([Banner].self, from: JSONSerialization.data(withJSONObject: topBannerSlidesArray))

            return Observable.just((books: books, topBannerSlides: topBannerSlides))
        } catch {
            print("Error decoding JSON: \(error)")
            return Observable.just((books: [], topBannerSlides: []))
        }
    }
}

