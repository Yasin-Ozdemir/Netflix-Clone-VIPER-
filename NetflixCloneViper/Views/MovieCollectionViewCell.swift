//
//  MovieCollectionViewCell.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 3.07.2024.
//

import UIKit
import SnapKit
import SDWebImage
class MovieCollectionViewCell: UICollectionViewCell {
    private let movieImageView : UIImageView = {
       let image = UIImageView()
        return image
    }()
    static let id = "generalCollection"
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubViews()
        applyConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieCollectionViewCell{
    func addSubViews(){
        addSubview(movieImageView)
    }
    func applyConstraint(){
        self.movieImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func configure(imageUrlPath : String?){
        guard let imageUrlPath = imageUrlPath else{
            self.movieImageView.image = UIImage(systemName: "placeholdertext.fill")
            return
        }
        print(imageUrlPath)
        DispatchQueue.main.async {
            self.movieImageView.sd_setImage(with: URL(string: NetworkConstants.imageBaseUrl + imageUrlPath))
        }
        
    }
}
