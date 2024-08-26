//
//  MovieRealmModel.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 22.08.2024.
//

import Foundation
import RealmSwift

class MovieRealmModel : Object {
    @Persisted(primaryKey: true) var RealmId: ObjectId
    @Persisted var name: String
    @Persisted var poster_path: String
    @Persisted var overview: String
    
    convenience init(name : String , posterPath : String , overview : String) {
        self.init()
        self.name = name
        self.poster_path = posterPath
        self.overview = overview
    }
}
