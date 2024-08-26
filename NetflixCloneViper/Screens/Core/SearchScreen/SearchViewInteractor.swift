//
//  SearchViewInteractor.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 6.07.2024.
//

import Foundation
protocol ISearchViewInteractor{
    func downloadMovies(url : String) async -> Result<[Results] , Error>
}
class SearchViewInteractor : ISearchViewInteractor {
    let networkManager : INetworkManager = NetworkManager()
    
    func downloadMovies(url : String) async -> Result<[Results] , Error> {
     let result =  await networkManager.request(url: url, model: Movies.self, method: .get, parameters: nil, headers: nil)
        switch result{
        case.success(let movie) :
            guard let movies = movie?.results else{
                return .failure(NetworkError.dataError)
            }
            return .success(movies)
        case .failure(let error) :
            return .failure(error)
        }
    }
}
