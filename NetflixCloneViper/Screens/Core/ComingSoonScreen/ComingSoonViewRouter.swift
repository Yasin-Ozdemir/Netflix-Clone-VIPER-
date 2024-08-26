//
//  ComingSoonViewRouter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 15.07.2024.
//

import Foundation
import UIKit
protocol IComingSoonViewRouter {
    var homeViewDelegate : UIViewController? {get set}
    func navigateToDetail(title: String, overView: String, posterPath: String)
}
class ComingSoonViewRouter : IComingSoonViewRouter {
    weak var homeViewDelegate : UIViewController?
    
    static func generateModule() -> UIViewController{
        var comingSoonView : IComingSoonViewController = ComigSoonViewController()
        var presenter : IComingSoonViewPresenter = ComingSoonViewPresenter()
        var interactor : IComingSoonViewInteractor = ComingSoonViewInteractor()
        var router : IComingSoonViewRouter = ComingSoonViewRouter()
        
        comingSoonView.presenter = presenter
        
        presenter.viewDelegate = comingSoonView
        presenter.interactor = interactor
        presenter.router = router
        
        router.homeViewDelegate = comingSoonView as? UIViewController
        
       return UINavigationController(rootViewController: comingSoonView as! UIViewController)
    }
    func navigateToDetail(title: String, overView: String, posterPath: String) {
        let detailVC = MovieDetailRouter.generateModule()
        detailVC.configureVC(title: title, overView: overView, posterPath: posterPath , downloadButtonHidden: true)
        homeViewDelegate?.navigationController?.customPushViewController(viewController: detailVC)
    }
}

