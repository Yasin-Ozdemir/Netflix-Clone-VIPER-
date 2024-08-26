//
//  Movie.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 5.07.2024.
//

import Foundation
// MARK: - Movie
struct Movies : Codable{
    let results: [Results]
}

// MARK: - Result
struct Results : Codable {
        let id: Int
       let media_type: String?
       let original_name: String?
       let original_title: String?
       let poster_path: String?
       let overview: String?
       let vote_count: Int
       let release_date: String?
       let vote_average: Double
}

