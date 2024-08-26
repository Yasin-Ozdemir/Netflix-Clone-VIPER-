//
//  HomeViewInteractor.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 5.07.2024.
//

import Foundation
protocol IHomeViewInteractor{
    func getMovies(url : String) async -> Result<[Results], Error>
}
class HomeViewInteractor : IHomeViewInteractor{
    private let networkManager = NetworkManager()
   
    func getMovies(url : String) async -> Result<[Results] , Error>{
        
        let result =  await networkManager.request(url: url, model: Movies.self, method: .get, parameters: nil, headers: nil)
        switch result {
        case.success(let movies) :
            guard let results = movies?.results else{
                return .failure(NetworkError.dataError)
            }
            return .success(results)
        case .failure(let err) : return .failure(err)
        }
    }
}
