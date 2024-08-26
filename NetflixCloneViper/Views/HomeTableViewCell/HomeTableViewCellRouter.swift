//
//  HomeTableViewCellRouter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 14.07.2024.
//

import Foundation
import UIKit
protocol IHomeTableViewCellRouter {
    func navigateToDetail( movieName : String , movieOverView : String , posterPath : String)
    var homeviewDelegate : UIViewController? { get set }
}
class HomeTableViewCellRouter : IHomeTableViewCellRouter {
    weak var homeviewDelegate : UIViewController?
    static func generateModule(cell : HomeTableViewCell , homeViewController : HomeViewController) -> HomeTableViewCell{
        
        cell.homeViewDelegate = homeViewController
        
       let presenter : IHomeTableViewPresenter = HomeTableViewPresenter()
        let interactor : IHomeTableViewInteractor = HomeTableViewInteractor()
        var router : IHomeTableViewCellRouter = HomeTableViewCellRouter()
        
        router.homeviewDelegate = homeViewController
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.viewDelegate = cell
        
        cell.presenter = presenter
        return cell
    }
    func navigateToDetail( movieName : String , movieOverView : String , posterPath : String){
        
        DispatchQueue.main.async {
            // MovieDetailRouterdan generate module yapılacak
            let detailView = MovieDetailRouter.generateModule()
           
            detailView.configureVC(title: movieName, overView: movieOverView , posterPath: posterPath)
            
            self.homeviewDelegate?.navigationController?.customPushViewController(viewController: detailView)
        }
        
    }
}

