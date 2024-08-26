//
//  DownloadsViewPresenter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 15.07.2024.
//

import Foundation
protocol IDownloadViewPresenter{
    func viewDidLoad()
    func numberOfRowsInSection() -> Int
    func removeMovie(with indexPath : IndexPath)
    var interactor : IDownloadsViewInteractor? {get set}
    var router : IDownloadsViewRouter? {get set}
    var viewDelegate : IDownloadsViewController? {get set}
    var downloadsMovies : [MovieRealmModel] {get set}
    
}

class DownloadsViewPresenter: IDownloadViewPresenter {
    weak var viewDelegate : IDownloadsViewController?
    var databaseManager : IDatabaseManager = DatabaseManager()
    var interactor : IDownloadsViewInteractor?
    var router : IDownloadsViewRouter?
    var downloadsMovies : [MovieRealmModel] = []
    func viewDidLoad(){
        viewDelegate?.setupNavigationController()
        viewDelegate?.addSubviews()
        viewDelegate?.applyConstraints()
        addObserverForDownloads()
        getMovies()
        
    }
    func numberOfRowsInSection() -> Int{
        return downloadsMovies.count
    }
    func removeMovie(with indexPath : IndexPath){
       let result =  interactor?.deleteMovie(movie: downloadsMovies[indexPath.row])
        switch result {
        case .success(_) : 
            self.downloadsMovies.remove(at: indexPath.row)
            updateView()
            break
        case .failure(_) :
            self.viewDelegate?.showError()
            break
        case .none:
            break
        }
        
    }
   private func addObserverForDownloads(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.getMovies()
            self.updateView()
            
        }
    }
   private func getMovies() {
            self.downloadsMovies =  interactor?.fetchMovies() ?? []
    }
   private func updateView(){
        DispatchQueue.main.async {
            self.viewDelegate?.reloadTableView()
        }
        
    }
    
}
