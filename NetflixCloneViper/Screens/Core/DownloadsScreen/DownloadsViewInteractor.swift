//
//  DownloadsViewInteractor.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 15.07.2024.
//

import Foundation

protocol IDownloadsViewInteractor {
    func fetchMovies()  -> [MovieRealmModel]
    func deleteMovie(movie : MovieRealmModel) -> Result<Void , Error>
}

class DownloadsViewInteractor : IDownloadsViewInteractor{
    let databaseManager : IDatabaseManager = DatabaseManager()
    
    func fetchMovies()  -> [MovieRealmModel]{
        let movies =  databaseManager.fetchMoviesFromDB()
        return movies
    }
    func deleteMovie(movie : MovieRealmModel) -> Result<Void , Error>{
        let result = databaseManager.deleteMovieFromDB(realmModel: movie)
        return result
    }
}
