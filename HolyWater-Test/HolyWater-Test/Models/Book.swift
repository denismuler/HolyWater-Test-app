//
//  Book.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 21.02.2024.
//

import Foundation

struct Book: Codable {
    let id: Int
    let name: String
    let summary: String
    let genre: String
    let coverUrl: String
    let likes: String
    let quotes: String
    
    enum CodingKeys: String, CodingKey {
          case id
          case name
          case summary
          case genre
          case coverUrl = "cover_url"
          case likes
          case quotes
      }
}

struct Section {
    let title: String
    let books: [Book]
}
