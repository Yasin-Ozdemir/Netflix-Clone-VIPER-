//
//  MovieDetailPresenter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 25.08.2024.
//

import Foundation
protocol IMovieDetailPresenter {
    var interactor : IMovieDetailInteractor! {get set}
    var viewDelegate : IMovieDetailViewController? {get set}
    var router : IMovieDetailRouter! {get set}
    func downloadMovieToDB(name : String , posterPath : String , overview : String)
    func getMovieTrailerUrl(name : String) async -> URLRequest?
}
class MovieDetailPresenter : IMovieDetailPresenter {
    var interactor : IMovieDetailInteractor!
    weak var viewDelegate : IMovieDetailViewController?
    var router : IMovieDetailRouter!
    
    func downloadMovieToDB(name : String , posterPath : String , overview : String){
        let result = interactor.saveMovie(name: name, posterPath: posterPath, overview: overview)
        
        switch result {
        case .success():
            sendDownloadNotification()
            viewDelegate?.showDownloadProgress()
        case .failure(_):
            viewDelegate?.showError()
        }
    }
    func sendDownloadNotification(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "downloaded"), object: nil)
    }
    func getMovieTrailerUrl(name : String) async -> URLRequest?{
     
          let result =  await interactor.getYoutubeVideoId(name: name)
        switch result {
        case .success(let videoID):
            if let url = URL(string: NetworkConstants.youtubeBaseUrl + videoID ) {
                return URLRequest(url: url)
            }else {
                self.viewDelegate?.showError()
                return nil
            }
            
        case .failure(_):
            viewDelegate?.showError()
            return nil
        }
           
        
        
    }
}
