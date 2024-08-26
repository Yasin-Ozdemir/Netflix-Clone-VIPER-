//
//  DownloadsViewController.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 2.07.2024.
//

import UIKit
protocol IDownloadsViewController : AnyObject {
    var presenter : IDownloadViewPresenter? {get set}
    func setupNavigationController()
    func addSubviews()
    func applyConstraints()
    func reloadTableView()
    func showError()
}

class DownloadsViewController: UIViewController {
    var presenter : IDownloadViewPresenter?
    private let downloadsTableView : UITableView = {
       let table = UITableView()
        table.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.id)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter?.viewDidLoad()
    }

}


extension DownloadsViewController : IDownloadsViewController {
    func reloadTableView() {
        self.downloadsTableView.reloadData()
    }
    
    func setupNavigationController(){
        self.navigationItem.title = "Downloads"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    func addSubviews(){
        view.addSubview(downloadsTableView)
    }
    func applyConstraints(){
        self.downloadsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func showError(){
        DispatchQueue.main.async {
            self.presentAlert(title: "Error", message: "Download Failure")
        }
        
    }
}


extension DownloadsViewController : UITableViewDelegate , UITableViewDataSource {
    func setupTableView(){
        self.downloadsTableView.dataSource = self
        self.downloadsTableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRowsInSection() ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = downloadsTableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.id, for: indexPath) as? GeneralTableViewCell else{
            return UITableViewCell()
        }
        let movie = presenter?.downloadsMovies[indexPath.row]
        
        cell.configure(movie: Results(id: 0, media_type: nil, original_name: movie?.name, original_title: nil, poster_path: movie?.poster_path, overview: movie?.overview, vote_count: 0, release_date: nil, vote_average: 0), playButtonActionEnabled: true )
        cell.viewControllerDelegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
                showDeleteAlert(indexPath: indexPath)
            
            
               
            
            
        }
    }
    func showDeleteAlert(indexPath : IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure want to delete this movie?", preferredStyle: UIAlertController.Style.alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) {[weak self] _ in
            guard let self = self else{
                return
            }
            self.presenter?.removeMovie(with: indexPath)
            self.downloadsTableView.deleteRows(at: [indexPath], with: .fade)
        }
        let noAction = UIAlertAction(title: "NO", style: .cancel)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true)
    }
    
}
