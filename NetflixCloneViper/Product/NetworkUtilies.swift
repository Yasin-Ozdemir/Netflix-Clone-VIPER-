//
//  NetworkUtilies.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 5.07.2024.
//

import Foundation
struct UrlFactory{
        static func createYoutubeUrl(movieName : String) -> String {
        "\(NetworkConstants.youtubeApiBaseUrl)\(movieName)+Trailer\(NetworkConstants.youtubeApiKey)"
    }
    static func createSearchUrl(with name : String) -> String {
        NetworkConstants.baseUrl + NetworkConstants.searchMovie + NetworkConstants.apiKey + NetworkParameters.createSearchParameter.rawValue + name
    }
}


enum NetworkParameters : String {
    case discoverMoviesParameter = "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
    case topRatedParameter = "&language=en-US&page=1"
    case createSearchParameter = "&query="
    
}




enum NetworkError : Error{
    case dataError
    case connectError
}

