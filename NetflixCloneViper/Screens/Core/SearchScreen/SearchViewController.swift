//
//  SearchViewController.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 2.07.2024.
//

import UIKit
import SnapKit
protocol ISearchViewController : AnyObject{
    var presenter : ISearchViewPresenter! {get set}
    func presentError()
    func reloadTableView()
    func setupNavigationController()
    func addSubviews()
    func applyConstraints()
    func goDetail(title : String , overView : String , posterPath : String)
}
class SearchViewController: UIViewController {
    var presenter : ISearchViewPresenter!
    private let searchTableView : UITableView = {
       let table = UITableView()
        table.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.id)
        return table
    }()
    private let searchController : UISearchController = {
       let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchBar.placeholder = "Search for a Movie or a Tv show"
        return searchController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black       
        setupTableView()
        setupSearchController()

        presenter.viewDelegate = self
        presenter.viewDidLoad()
    }
    

}
extension SearchViewController : ISearchViewController {
    func goDetail(title : String , overView : String , posterPath : String) {
        presenter.goDetailVc(title: title, overView: overView, posterPath: posterPath)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
        }
    }
    
    func presentError() {
        DispatchQueue.main.async {
            self.presentAlert(title: "ERROR", message: "Network Error")
        }
        
    }
    func setupNavigationController(){
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.searchController = self.searchController
    }
    
    func addSubviews(){
        view.addSubview(searchTableView)
    }
    func applyConstraints(){
        self.searchTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension SearchViewController : UITableViewDelegate , UITableViewDataSource {
    func setupTableView(){
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.id, for: indexPath) as? GeneralTableViewCell else{
            return UITableViewCell()
        }
        let movie = presenter.getMovieList()[indexPath.row]
        cell.configure(movie: movie, playButtonActionEnabled: false)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
    
}
extension SearchViewController : UISearchResultsUpdating {
    func setupSearchController(){
        self.searchController.searchResultsUpdater = self
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text , query.trimmingCharacters(in: .whitespaces).isEmpty == false , query.trimmingCharacters(in: .whitespaces).count > 2 ,
              let resultController = searchController.searchResultsController as? SearchResultViewController else{
                  return
              }
        if let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
            Task{
                await presenter.searchMovie(name: query)
            }
            resultController.searchVcDelegate = self
            resultController.setMovies(movies: presenter.getSearchResultMovies())
        
        }
        
    }
}
