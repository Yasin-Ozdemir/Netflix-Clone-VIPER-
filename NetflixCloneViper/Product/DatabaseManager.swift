//
//  DatabaseManager.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 12.07.2024.
//

import Foundation
import RealmSwift
protocol IDatabaseManager {
    func saveMovieToDB(name: String, posterPath: String, overview: String)  -> Result<Void , Error>
    func fetchMoviesFromDB()  ->[MovieRealmModel]
    func deleteMovieFromDB(realmModel: MovieRealmModel) -> Result<Void , Error>
}
class DatabaseManager : IDatabaseManager{
   private let realm = try! Realm()


    func saveMovieToDB(name: String, posterPath: String, overview: String)  -> Result<Void , Error>{
        let realmModel = MovieRealmModel(name: name, posterPath: posterPath, overview: overview)
      
        do {
            try realm.write {
                realm.add(realmModel)
            }
        }catch{
            return .failure(DatabaseError.saveError)
        }
        return .success(())
    }
    func fetchMoviesFromDB()  ->[MovieRealmModel] {
        var movieArray : [MovieRealmModel] = []
       
            let movies = realm.objects(MovieRealmModel.self)
            for movie in movies {
                movieArray.append(movie)
            }
        
            return movieArray
 
    }
    func deleteMovieFromDB(realmModel: MovieRealmModel) -> Result<Void , Error>{
        do{
            try  realm.write {
                realm.delete(realmModel)
            }
        }catch{
            return .failure(DatabaseError.deleteError)
        }
        return .success(())
       
    }
}

