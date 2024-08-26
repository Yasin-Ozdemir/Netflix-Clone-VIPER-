//
//  MainTabBarController.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 2.07.2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    private  let homeVC = HomeViewRouter.generateModule()
    private let searchVC = SearchViewRouter.generateModule()
    private let comingSoonVC = ComingSoonViewRouter.generateModule()
    private let downloadsVC = DownloadsViewRouter.generateModule()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarItems()
        
    }
    
    private func setupViewControllers(){
      setViewControllers([homeVC , comingSoonVC , searchVC , downloadsVC], animated: true)
    }
    
   private func setupTabBarItems(){
        homeVC.tabBarItem.title = "Home"
        searchVC.tabBarItem.title = "Search"
        comingSoonVC.tabBarItem.title = "Coming Soon"
        downloadsVC.tabBarItem.title = "Downloads"
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        comingSoonVC.tabBarItem.image = UIImage(systemName: "play.circle")
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down.circle")
        self.tabBar.tintColor = .label
    }
    
    
}
