//
//  HomeTableViewInteractor.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 14.07.2024.
//

import Foundation

protocol IHomeTableViewInteractor {
    func saveMovie(movie : Results)  -> Result<Void , Error>
    func getYoutubeVideoId(name : String?)async -> Result<String? , Error>
}

class HomeTableViewInteractor : IHomeTableViewInteractor{
    let databaseManager : IDatabaseManager = DatabaseManager()
    let networkManager : INetworkManager = NetworkManager()
    weak var presenter : IHomeTableViewPresenter?
  
   
    func saveMovie(movie : Results)  -> Result<Void , Error>{
     let result =    databaseManager.saveMovieToDB(name: movie.original_name ?? movie.original_title ?? "", posterPath: movie.poster_path!, overview: movie.overview!)
      return result
    }
    func getYoutubeVideoId(name : String?)async -> Result<String? , Error>{
      
        guard let name = name , let movieName =  name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) else{
            return .failure(NetworkError.connectError)
        }
        
        let result = await  networkManager.request(url: UrlFactory.createYoutubeUrl(movieName: movieName), model: YoutubeVideo.self, method: .get, parameters: nil, headers: nil)
        
        switch result {
    case .success(let video) :
            return .success( video!.items[0].id.videoId)
        case .failure(let error):
            print(error)
            return .failure(error)
        }
    }
}

