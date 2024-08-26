//
//  TrailerView.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 26.08.2024.
//

import Foundation
import UIKit
import WebKit
import SnapKit
protocol ITrailerViewController : AnyObject {
    var presenter : ITrailerViewPresenter! {get set}
    func configure(name : String)
}
class TrailerView : UIViewController , ITrailerViewController{
    
    var presenter : ITrailerViewPresenter!
    private let webKit : WKWebView = {
       let webKit = WKWebView()
        webKit.translatesAutoresizingMaskIntoConstraints = false
       webKit.isHidden = true
        return webKit
    }()
    private let indicator : UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .red
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webKit)
        view.addSubview(indicator)
        applyConstraints()
        setupNavBar()
        self.view.backgroundColor = .black
    }
    func applyConstraints() {
        self.indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.webKit.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(250)
            make.width.equalTo(400)
        }
    }
    func configure(name : String){
        self.indicator.startAnimating()
        Task {
            guard let request = await presenter.getMovieTrailerUrl(name: name) else {
                self.presentAlert(title: "ERROR!", message: "Trailer didn't load")
                return
            }
            DispatchQueue.main.async {
                self.webKit.load(request)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.indicator.stopAnimating()
                    self.webKit.isHidden = false
                }
            }
            
        }
       
    }
    func setupNavBar(){
        self.navigationController?.navigationBar.tintColor = .label
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeScreen))
        self.navigationItem.leftBarButtonItem = closeButton
    }
    @objc func closeScreen(){
        self.dismiss(animated: true)
    }
  
    
}
