//
//  MovieDetailRouter.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 25.08.2024.
//

import Foundation
import UIKit
protocol IMovieDetailRouter {
    
}
class MovieDetailRouter : IMovieDetailRouter {
    static func generateModule() -> MovieDetailViewController{
        var presenter : IMovieDetailPresenter = MovieDetailPresenter()
        let interactor : IMovieDetailInteractor = MovieDetailInteractor()
        let view : IMovieDetailViewController = MovieDetailViewController()
        
        view.presenter = presenter
        
        presenter.viewDelegate = view
        presenter.interactor = interactor
        
        return view as! MovieDetailViewController 
    }
}
