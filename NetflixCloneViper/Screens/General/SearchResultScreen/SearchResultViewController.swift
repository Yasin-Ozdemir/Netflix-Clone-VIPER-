//
//  SearchResultViewController.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 2.07.2024.
//

import UIKit

class SearchResultViewController: UIViewController {
    private var movies = [Results]()
    weak var searchVcDelegate : ISearchViewController?
    private let movieCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 15, right: 5)
        layout.itemSize = CGSize(width: 120, height: 170)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.id)
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        addSubViews()
        applyConstraints()
    }
    

}
extension SearchResultViewController {
    private func addSubViews(){
        view.addSubview(movieCollectionView)
    }
    private func applyConstraints(){
        self.movieCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setMovies(movies : [Results]){
        self.movies = movies
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
    }
    
}
extension SearchResultViewController : UICollectionViewDelegate , UICollectionViewDataSource{
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
        let imageUrlPath = self.movies[indexPath.row].poster_path
        cell.configure(imageUrlPath: imageUrlPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let name = self.movies[indexPath.item].original_name ?? self.movies[indexPath.item].original_title , let overView = self.movies[indexPath.item].overview , let posterPath = self.movies[indexPath.item].poster_path else {
            return
        }
        searchVcDelegate?.goDetail(title: name, overView: overView, posterPath: posterPath)
    }
}
