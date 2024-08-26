//
//  ComingSoonViewPresenter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 6.07.2024.
//

import Foundation
protocol IComingSoonViewPresenter {
    var viewDelegate : IComingSoonViewController? { get set }
    var interactor : IComingSoonViewInteractor! {get set}
    var router : IComingSoonViewRouter! {get set}
    func fetchDiscoverMovies() async
    func getMovieList() -> [Results]
    func numberOfRowsInSection() -> Int
    func viewDidLoad()
    func didSelectRow(at indexPath : IndexPath)
}
class ComingSoonViewPresenter : IComingSoonViewPresenter {
    
    
    weak var viewDelegate : IComingSoonViewController?
    
    var interactor : IComingSoonViewInteractor!
    var router : IComingSoonViewRouter!
   private var movieList : [Results] = []
    private var comingSoonMoviesUrl = NetworkConstants.baseUrl + NetworkConstants.upcomingMovie + NetworkConstants.apiKey
    
    func viewDidLoad(){
        viewDelegate?.setupNavigationController()
        viewDelegate?.addSubviews()
        viewDelegate?.applyConstraints()
        Task{
            await fetchDiscoverMovies()
        }
    }
    func fetchDiscoverMovies() async{
      let result = await interactor.downloadDiscoverMovies(url: comingSoonMoviesUrl)
        switch result {
        case .success(let movies):
           print(movies)
            self.movieList = movies
            viewDelegate?.reloadTableView()
            
        case .failure(let error):
            viewDelegate?.presentError()
        }
    }
    
    func getMovieList() -> [Results]{
        return self.movieList
    }
    
    func numberOfRowsInSection() -> Int{
        return self.movieList.count
    }
    func didSelectRow(at indexPath : IndexPath) {
        guard let title = self.movieList[indexPath.row].original_name ?? self.movieList[indexPath.row].original_title , let overView = self.movieList[indexPath.row].overview , let posterPath = self.movieList[indexPath.row].poster_path else {
            return
        }
        router.navigateToDetail(title: title, overView: overView, posterPath: posterPath)
    }
}
