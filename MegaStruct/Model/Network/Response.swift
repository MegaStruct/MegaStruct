//
//  Response.swift
//  MegaStruct
//
//  Created by 김정호 on 4/24/24.
//

import Foundation

struct Response: Decodable {
    let page: Int?
    let results: [Movie]
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Decodable {
    let adult: Bool?
    let genreIDS: [Int]
    let id: Int?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case genreIDS = "genre_ids"
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
