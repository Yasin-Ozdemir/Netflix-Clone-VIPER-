//
//  SearchViewPresenter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 6.07.2024.
//

import Foundation
protocol ISearchViewPresenter {
    var viewDelegate : ISearchViewController? { get set }
    var interactor : ISearchViewInteractor! { get set }
    var router : ISearchViewRouter! {get set}
    func fetchDiscoverMovies() async
    func searchMovie(name : String) async
    func getMovieList() -> [Results]
    func numberOfRowsInSection() -> Int
    func getSearchResultMovies() -> [Results]
    func viewDidLoad()
    func didSelectRow(at indexPath : IndexPath)
    func goDetailVc(title: String, overView: String, posterPath: String)
}
class SearchViewPresenter : ISearchViewPresenter {
    weak var viewDelegate : ISearchViewController?
    var interactor : ISearchViewInteractor!
    var router : ISearchViewRouter!
   private var movieList : [Results] = []
    private var searchResultMovies = [Results]()
    private let discoverMovieUrl = NetworkConstants.baseUrl + NetworkConstants.discoverMovie + NetworkConstants.apiKey + NetworkParameters.discoverMoviesParameter.rawValue
    
    func viewDidLoad(){
        viewDelegate?.setupNavigationController()
        viewDelegate?.addSubviews()
        viewDelegate?.applyConstraints()

        Task{
            await fetchDiscoverMovies()
        }
    }
    func fetchDiscoverMovies() async{
        print("fetching is starting...")
      let result = await interactor.downloadMovies(url: discoverMovieUrl)
        switch result {
        case .success(let movies):
           print(movies)
            self.movieList = movies
            viewDelegate?.reloadTableView()
            
        case .failure(let error):
            viewDelegate?.presentError()
        }
    }
    func searchMovie(name : String) async{
        
        let result = await interactor.downloadMovies(url: UrlFactory.createSearchUrl(with: name))
        switch result {
        case .success(let movies):
            self.searchResultMovies = movies
        case .failure(let failure):
            viewDelegate?.presentError()
        }
        
    }
    func getSearchResultMovies() -> [Results]{
        return self.searchResultMovies
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
       goDetailVc(title: title, overView: overView, posterPath: posterPath)
    }
    func goDetailVc(title: String, overView: String, posterPath: String){
        router.navigateToDetail(title: title, overView: overView, posterPath: posterPath)
    }
}
