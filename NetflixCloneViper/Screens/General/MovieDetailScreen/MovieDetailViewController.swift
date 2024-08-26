//
//  MovieDetailViewController.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 3.07.2024.
//

import UIKit
import WebKit
import SnapKit
import JGProgressHUD
protocol IMovieDetailViewController : AnyObject {
    var presenter : IMovieDetailPresenter! {get set}
     func addSubViews()
    func applyConstraints()
    func showDownloadProgress()
    func showError()
    func configureVC(title : String , overView : String , posterPath : String , downloadButtonHidden : Bool)
}
class MovieDetailViewController: UIViewController {
    var presenter : IMovieDetailPresenter!
    var moviePosterPath : String = ""
    private let progressHud : JGProgressHUD = {
       let hud = JGProgressHUD()
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.textLabel.text = "Downloading"
        hud.detailTextLabel.text = "%0"
        return hud
    }()
    private var indicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .red
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let overviewTxtView : UITextView = {
       let txt = UITextView()
        txt.isEditable = false
        txt.font = .systemFont(ofSize: 16)
        txt.textColor = .label
        return txt
    }()
       
       private let titleLabel : UILabel = {
           let label = UILabel()
             label.textAlignment = .left
             label.textColor = .label
             label.font = .systemFont(ofSize: 22)
             label.translatesAutoresizingMaskIntoConstraints = false
             return label
       }()
       
       private let webKit : WKWebView = {
          let webKit = WKWebView()
           webKit.translatesAutoresizingMaskIntoConstraints = false
          webKit.isHidden = true
           return webKit
       }()
       
       private let downloadButton : UIButton = {
          let button = UIButton()
           button.setTitle("Download", for: UIControl.State.normal)
           button.setTitleColor(.white, for: UIControl.State.normal)
           button.backgroundColor = .red
           button.translatesAutoresizingMaskIntoConstraints = false
           button.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
           return button
       }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        applyConstraints()
    }
    func configureVC(title : String , overView : String , posterPath : String , downloadButtonHidden : Bool = false){
       
        self.titleLabel.text = title
        self.overviewTxtView.text = overView
        self.downloadButton.isHidden = downloadButtonHidden
        moviePosterPath = posterPath
        setupWebKit(title: title)
    }
    func setupWebKit(title : String){
        
        self.indicator.startAnimating()
            Task {
                
                guard let result =  await self.presenter.getMovieTrailerUrl(name: title) else{
                    return
                }
                DispatchQueue.main.async {
                    self.webKit.load(result)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.indicator.stopAnimating()
                        self.webKit.isHidden = false
                    }
                   
                }
            }
        
    }
    @objc func downloadButtonAction(){
        presenter.downloadMovieToDB(name: titleLabel.text!, posterPath: moviePosterPath, overview: overviewTxtView.text!)
    }

}
extension MovieDetailViewController : IMovieDetailViewController{
    func addSubViews(){
       
       self.view.addSubview(overviewTxtView)
       self.view.addSubview(titleLabel)
       
       self.view.addSubview(downloadButton)
       self.view.addSubview(webKit)
       self.view.addSubview(indicator)
    }
     func applyConstraints(){
        self.webKit.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().inset(4)
            make.top.equalToSuperview().offset(50)
            make.height.equalToSuperview().multipliedBy(0.40)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.webKit.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(4)
        }
        self.overviewTxtView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().inset(4)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        self.downloadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.overviewTxtView.snp.bottom).offset(2)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        self.indicator.snp.makeConstraints { make in
            make.centerX.equalTo(self.webKit.snp.centerX)
            make.centerY.equalTo(self.webKit.snp.centerY)
        }
    }
    func showDownloadProgress() {
        progressHud.show(in: view)
        var progress : Float =  0.0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.1
            self.progressHud.setProgress(progress, animated: true)
            let value = progress / 1
            self.progressHud.detailTextLabel.text = "%\(Int(value * 100))"
            if progress > 1 {
                timer.invalidate()
                self.progressHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.progressHud.detailTextLabel.text = nil
                self.progressHud.textLabel.text = "Done!"
                self.progressHud.dismiss(afterDelay: 2, animated: true)
            }
        }
    }
    func showError(){
        self.presentAlert(title: "ERROR", message: "Download Failure")
    }
    
}
