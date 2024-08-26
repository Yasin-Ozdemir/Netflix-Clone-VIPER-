//
//  HomeViewRouter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 15.07.2024.
//

import Foundation
import UIKit
protocol IHomeViewRouter {
    var homeViewDelegate : UIViewController? { get set}
}

class HomeViewRouter  : IHomeViewRouter{
    weak var homeViewDelegate : UIViewController?
    
    static func generateModule() -> UIViewController{
        
        let homeView : IHomeViewController = HomeViewController()
        var presenter : IHomeViewPresenter = HomeViewPresenter()
        let interactor : IHomeViewInteractor = HomeViewInteractor()
        var router : IHomeViewRouter = HomeViewRouter()
        homeView.presenter = presenter
        
        presenter.interactor = interactor
        presenter.homeViewDelegate = homeView
        presenter.router = router
        
        router.homeViewDelegate = homeView as? UIViewController
        
        return UINavigationController(rootViewController: homeView as! UIViewController)
    }
}
