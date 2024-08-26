//
//  HomeTableViewPresenter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 14.07.2024.
//

import Foundation

protocol IHomeTableViewPresenter : AnyObject {
    func downloadMovie(movie : Results)
    func sendDownloadNotification()
    func showError(error : Error)
    func goDetailVC(movie : Results)
    var interactor : IHomeTableViewInteractor? { get set }
    var router : IHomeTableViewCellRouter? {get set}
    var viewDelegate : IHomeTableViewCell? {get set}
    
}
class HomeTableViewPresenter : IHomeTableViewPresenter {
    
    
    var interactor : IHomeTableViewInteractor?
    weak var viewDelegate : IHomeTableViewCell?
    var router : IHomeTableViewCellRouter?
    func downloadMovie(movie : Results){
        
        let result =  interactor?.saveMovie(movie: movie)
        switch result {
        case .success(_) : 
            viewDelegate?.showDownloading()
            sendDownloadNotification(); break
        case .failure(let err) : showError(error: err); break
        case .none: break
        }
            
    }
    func goDetailVC(movie : Results){
       
           
            
            guard let movieName = movie.original_name ?? movie.original_title , let overview = movie.overview , let posterPath = movie.poster_path else {
                self.showError(error: NetworkError.dataError)
                return
            }
                router?.navigateToDetail(movieName: movieName, movieOverView: overview, posterPath: posterPath)
          
        
    }
  
    func sendDownloadNotification(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "downloaded"), object: nil)
    }
    func showError(error : Error){
        DispatchQueue.main.async {
            self.viewDelegate?.showError(errorString: error.localizedDescription)

        }
    }
}
