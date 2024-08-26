//
//  HomeViewPresenter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 5.07.2024.
//

import Foundation

protocol IHomeViewPresenter{
    var homeViewDelegate:  IHomeViewController? { get set }
    var interactor : IHomeViewInteractor! { get set }
    var router : IHomeViewRouter! {get set}
    func viewDidLoad()
    func fetchMovies(title : Titles)async
    func getMovieList() -> [Results]
   
}
class HomeViewPresenter : IHomeViewPresenter{
    
    weak var homeViewDelegate:  IHomeViewController?
    private var movieList = [Results]()
    var interactor : IHomeViewInteractor!
    var router : IHomeViewRouter!
    func viewDidLoad(){
        homeViewDelegate?.setupNavigationController()
        homeViewDelegate?.addSubViews()
        homeViewDelegate?.applyConstraints()
        
    }
    
    func fetchMovies(title : Titles) async{
        self.movieList.removeAll()
        var url = ""
        switch title{
        case .trendingMovies : url = NetworkConstants.baseUrl + NetworkConstants.trendingMovie + NetworkConstants.apiKey
        case .trendingTV : url = NetworkConstants.baseUrl + NetworkConstants.trendingTV + NetworkConstants.apiKey
        case .upcoming : url = NetworkConstants.baseUrl + NetworkConstants.upcomingMovie + NetworkConstants.apiKey
        case .popular : url = NetworkConstants.baseUrl + NetworkConstants.popularMovie + NetworkConstants.apiKey
        case .topRated : url = NetworkConstants.baseUrl + NetworkConstants.topRated + NetworkConstants.apiKey + NetworkParameters.topRatedParameter.rawValue
        }
        let result = await interactor.getMovies(url: url)
        switch result{
        case.success(let movies) :
            DispatchQueue.main.async {
                self.movieList = movies
            }
          
        case .failure(let error) :
            homeViewDelegate?.presentError(message: error.localizedDescription)
        }
    }
    func getMovieList() -> [Results]{
        return movieList
    }
}
