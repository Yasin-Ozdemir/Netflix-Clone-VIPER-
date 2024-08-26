//
//  HomeTableViewCell.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 2.07.2024.
//

import UIKit
import SnapKit
protocol IHomeTableViewCell: AnyObject{
    func showError(errorString : String)
    func showDownloading()
}
class HomeTableViewCell: UITableViewCell {
    var movies = [Results]()
    weak var homeViewDelegate : IHomeViewController?
    var presenter : IHomeTableViewPresenter?
    private let movieCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.id)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    static let id = "homeTable"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
        addSubViews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension HomeTableViewCell{
    private func addSubViews(){
        contentView.addSubview(movieCollectionView)
    }
    private func applyConstraints(){
        self.movieCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func configure(movieList : [Results]){
       
        DispatchQueue.main.async {
            self.movies = movieList
            self.movieCollectionView.reloadData()
        }
        
    }
   
    private  func downloadMovie(index : Int){
        self.presenter?.downloadMovie(movie: self.movies[index])
    }
    
}

extension HomeTableViewCell : IHomeTableViewCell {
    func showError(errorString: String) {
        homeViewDelegate?.presentError(message: errorString)
    }
    func showDownloading(){
        homeViewDelegate?.showDownloadProgress()
    }
}

extension HomeTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource{
    func setupCollectionView(){
        self.movieCollectionView.delegate = self
        self.movieCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.movieCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.id, for: indexPath) as? MovieCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.configure(imageUrlPath: self.movies[indexPath.row].poster_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("aaaaa")
        presenter?.goDetailVC(movie: self.movies[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        // Uzun basıldığında watch trailer ve download seçenekleri çıkacak
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", state: .off) { [weak self] _ in
                guard let self = self else{
                    return
                }
                self.downloadMovie(index: indexPaths[0].item)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return configuration
    }
}
