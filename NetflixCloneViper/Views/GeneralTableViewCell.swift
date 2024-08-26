//
//  GeneralTableViewCell.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 2.07.2024.
//

import UIKit
import SnapKit
import WebKit
import SDWebImage

class GeneralTableViewCell: UITableViewCell {
    static let id = "generalTable"
    weak var viewControllerDelegate : UIViewController?
    private let webKit : WKWebView = {
       let webKit = WKWebView()
        webKit.translatesAutoresizingMaskIntoConstraints = false
       webKit.isHidden = true
        return webKit
    }()
    private let movieImageView : UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = false
        image.image = UIImage(systemName: "placeholdertext.fill")
        image.tintColor = .label
        return image
    }()
    private let movieNameLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .label
        label.text = "Fjfsakfjsaffjla"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private let playButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.tintColor = .label
        button.isEnabled = true
        return button
    }()
    
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(movie : Results , playButtonActionEnabled : Bool){
        guard let movieName = movie.original_title ?? movie.original_name , let imagePath = movie.poster_path else{
            self.movieNameLabel.text = "Didn't Find"
            self.movieImageView.image = UIImage(systemName: "placeholdertext.fill")
            return
        }
        self.movieNameLabel.text = movieName
        self.movieImageView.sd_setImage(with: URL(string: NetworkConstants.imageBaseUrl + imagePath))
        if playButtonActionEnabled {
            self.playButton.addTarget(self, action: #selector(watchTrailer), for: .touchUpInside)
        }
    }
    @objc func watchTrailer(){
        let view = TrailerViewRouter.generateModule(movieName: self.movieNameLabel.text!)
       
        viewControllerDelegate?.present(view, animated: true)
    }
}
extension GeneralTableViewCell {
    
   private func addSubViews(){
        addSubview(movieImageView)
        addSubview(movieNameLabel)
       contentView.addSubview(playButton)
    }
   private func applyConstraints(){
       self.movieImageView.snp.makeConstraints { make in
           make.centerY.equalToSuperview()
           make.height.equalToSuperview().multipliedBy(0.90)
           make.width.equalToSuperview().multipliedBy(0.22)
           make.leading.equalToSuperview().offset(5)
       }
       self.movieNameLabel.snp.makeConstraints { make in
           make.centerY.equalToSuperview()
           make.leading.equalTo(self.movieImageView.snp.trailing).offset(15)
           make.trailing.equalTo(playButton.snp.leading).inset(2)
       }
       self.playButton.snp.makeConstraints { make in
           make.centerY.equalToSuperview()
           make.trailing.equalToSuperview().inset(3)
           make.height.equalTo(55)
           make.width.equalTo(55)
       }
    }

    
}
