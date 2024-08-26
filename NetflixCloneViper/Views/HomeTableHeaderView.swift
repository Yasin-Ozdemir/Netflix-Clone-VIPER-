//
//  HomeTableHeaderView.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 3.07.2024.
//

import UIKit
import SnapKit
class HomeTableHeaderView: UIView {

    private let headerImage : UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = false
        imageView.image = UIImage(named: "lordoftherings")
        return imageView
    }()
    private let downloadButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Download", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]), for: UIControl.State.normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()
    private let playButton : UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: "Play", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]), for: UIControl.State.normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        addSubViews()
      
        applyConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeTableHeaderView {
    private func addSubViews(){
        addSubview(headerImage)
        addGradient()
        addSubview(downloadButton)
        addSubview(playButton)
    }
    private func applyConstraints(){
        self.headerImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.downloadButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.trailing.equalToSuperview().inset(70)
            make.bottom.equalToSuperview().inset(50)
        }
        self.playButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.leading.equalToSuperview().offset(70)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    private func addGradient(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor , UIColor.systemBackground.cgColor]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
