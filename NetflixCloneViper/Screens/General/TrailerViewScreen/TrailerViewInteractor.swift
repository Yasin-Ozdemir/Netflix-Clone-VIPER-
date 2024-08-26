//
//  TrailerViewInteractor.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 26.08.2024.
//

import Foundation
protocol ITrailerViewInteractor {
    func getYoutubeVideoId(name : String?)async -> Result<String , Error>
}
class TrailerViewInteractor : ITrailerViewInteractor {
    private let networkManager : INetworkManager = NetworkManager()
    func getYoutubeVideoId(name : String?)async -> Result<String , Error>{
      
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

