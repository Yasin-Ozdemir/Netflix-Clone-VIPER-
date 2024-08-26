//
//  YoutubeVideo.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 25.07.2024.
//

import Foundation

struct YoutubeVideo: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: Video
}


struct Video: Codable {
    let kind: String
    let videoId: String
}





