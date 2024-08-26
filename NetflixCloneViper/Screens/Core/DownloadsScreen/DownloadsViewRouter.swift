//
//  DownloadsViewRouter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 15.07.2024.
//

import Foundation
import UIKit

protocol IDownloadsViewRouter {
    var viewDelegate : IDownloadsViewController? {get set}
}


class DownloadsViewRouter : IDownloadsViewRouter{
   weak var viewDelegate : IDownloadsViewController?
   
    static func generateModule() -> UIViewController{
        let viewController : IDownloadsViewController = DownloadsViewController()
        
        var presenter : IDownloadViewPresenter = DownloadsViewPresenter()
        let interactor : IDownloadsViewInteractor = DownloadsViewInteractor()
        var router : IDownloadsViewRouter = DownloadsViewRouter()
        
        router.viewDelegate = viewController
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.viewDelegate = viewController
        
        viewController.presenter = presenter
 
    
        return UINavigationController(rootViewController: viewController as! UIViewController)
        
    }
    
}
