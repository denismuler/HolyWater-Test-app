//
//  Banner.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 22.02.2024.
//

import Foundation

struct Banner: Codable {
    let id: Int
    let bookId: Int
    let cover: String
    
    enum CodingKeys: String, CodingKey {
          case id
          case bookId = "book_id"
          case cover
      }
}
