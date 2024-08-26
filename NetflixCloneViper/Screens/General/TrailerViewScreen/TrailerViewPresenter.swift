//
//  TrailerViewPresenter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 26.08.2024.
//

import Foundation
protocol ITrailerViewPresenter {
    var interactor : ITrailerViewInteractor! {get set}
    var router : ITrailerViewRouter! {get set}
    func getMovieTrailerUrl(name : String) async -> URLRequest?
}
class TrailerViewPresenter  : ITrailerViewPresenter{
    var router:  ITrailerViewRouter!
    
    var interactor : ITrailerViewInteractor!
    
    func getMovieTrailerUrl(name : String) async -> URLRequest?{
     
        let result =  await interactor.getYoutubeVideoId(name: name)
        switch result {
        case .success(let videoID):
            if let url = URL(string: NetworkConstants.youtubeBaseUrl + videoID ) {
                return URLRequest(url: url)
            }else {
               
                return nil
            }
            
        case .failure(_):
            return nil
        }
           
        
        
    }
}
