//
//  TrailerViewRouter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 26.08.2024.
//

import Foundation
import UIKit
protocol ITrailerViewRouter {
    var viewDelegate : ITrailerViewController? {get set}
}
class TrailerViewRouter : ITrailerViewRouter{
  weak  var viewDelegate: ITrailerViewController?
    
    
    static func generateModule(movieName : String) -> UIViewController{
        var view : ITrailerViewController = TrailerView()
        var presenter : ITrailerViewPresenter = TrailerViewPresenter()
        var interactor : ITrailerViewInteractor = TrailerViewInteractor()
        var router : ITrailerViewRouter = TrailerViewRouter()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        
        router.viewDelegate = view
        view.configure(name: movieName)
        return UINavigationController(rootViewController: view as! UIViewController)
    }
}
