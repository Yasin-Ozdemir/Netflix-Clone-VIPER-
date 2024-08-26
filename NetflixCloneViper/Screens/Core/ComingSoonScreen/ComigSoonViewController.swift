//
//  ComigSoonViewController.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 2.07.2024.
//

import UIKit
protocol IComingSoonViewController : AnyObject{
    var presenter : IComingSoonViewPresenter! {get set}
    func presentError()
    func reloadTableView()
    func setupNavigationController()
    func addSubviews()
    func applyConstraints()
}
class ComigSoonViewController: UIViewController {
    var presenter : IComingSoonViewPresenter!
    private let comingSoonTableView : UITableView = {
       let table = UITableView()
        table.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.id)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        setupTableView()
        presenter.viewDidLoad()
    }
    
    
}
extension ComigSoonViewController : IComingSoonViewController {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.comingSoonTableView.reloadData()
        }
    }
    
    func presentError() {
        self.presentAlert(title: "ERROR", message: "Network Error")
    }
    func setupNavigationController(){
        self.navigationItem.title = "Coming Soon"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    func addSubviews(){
        view.addSubview(comingSoonTableView)
    }
    func applyConstraints(){
        self.comingSoonTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
extension ComigSoonViewController : UITableViewDelegate , UITableViewDataSource {
    func setupTableView(){
        self.comingSoonTableView.dataSource = self
        self.comingSoonTableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = comingSoonTableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.id, for: indexPath) as? GeneralTableViewCell else{
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

