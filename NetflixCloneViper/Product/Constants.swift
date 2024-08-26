//
//  Constants.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 5.07.2024.
//

import Foundation

struct NetworkConstants{
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let apiKey = "api_key=697d439ac993538da4e3e60b54e762cd"
    static let youtubeApiBaseUrl = "https://youtube.googleapis.com/youtube/v3/search?q="
    static let youtubeApiKey = "&key=AIzaSyBPMjmm-fJp7_351eZ4E5uno7hnhewF4to"
    static let youtubeBaseUrl = "https://www.youtube.com/embed/"
    static let trendingMovie = "trending/movie/day?"
    static let trendingTV = "trending/tv/day?"
    static let upcomingMovie = "movie/upcoming?"
    static let popularMovie = "movie/popular?"
    static let topRated = "movie/top_rated?"
   static let discoverMovie =  "discover/movie?"
    static let searchMovie = "search/movie?"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
}
