//
//  SearchViewRouter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 15.07.2024.
//

import Foundation
import UIKit
protocol ISearchViewRouter {
    var homeViewDelegate : UIViewController? {get set}
    func navigateToDetail(title: String, overView: String, posterPath: String)
}
class SearchViewRouter : ISearchViewRouter{
    weak var homeViewDelegate : UIViewController?
    
    static func generateModule() -> UIViewController{
        var searchView : ISearchViewController = SearchViewController()
        var presenter : ISearchViewPresenter = SearchViewPresenter()
        var interactor : ISearchViewInteractor = SearchViewInteractor()
        var router : ISearchViewRouter = SearchViewRouter()
        
        searchView.presenter = presenter
        
        presenter.viewDelegate = searchView
        presenter.interactor = interactor
        presenter.router = router
        
        router.homeViewDelegate = searchView as? UIViewController
        
       return UINavigationController(rootViewController: searchView as! UIViewController)
    }
    func navigateToDetail(title: String, overView: String, posterPath: String) {
        let detailVC = MovieDetailRouter.generateModule()
        detailVC.configureVC(title: title, overView: overView, posterPath: posterPath)
        homeViewDelegate?.navigationController?.customPushViewController(viewController: detailVC)
    }
}
