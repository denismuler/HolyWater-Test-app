//
//  Carousel.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 23.02.2024.
//

import Foundation

struct Carousel: Codable {
    let id: Int
    let name: String
    let author: String
    let summary: String
    let genre: String
    let coverUrl: String
    let views: String
    let likes: String
    let quotes: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case author
        case summary
        case genre
        case coverUrl = "cover_url"
        case views
        case likes
        case quotes
      }
}
