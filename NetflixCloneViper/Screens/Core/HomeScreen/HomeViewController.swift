//
//  HomeViewController.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 2.07.2024.
//

import UIKit
import SnapKit
import JGProgressHUD
enum Titles : Int {
    case trendingMovies = 0
    case trendingTV = 1
    case popular = 2
    case upcoming = 3
    case topRated = 4
}
protocol IHomeViewController : AnyObject{
    var presenter : IHomeViewPresenter! { get set }
    func reloadTable()
    func presentError(message : String)
    func setupNavigationController()
    func applyConstraints()
    func addSubViews()
    func showDownloadProgress()
}

class HomeViewController: UIViewController {
   
    
    var presenter : IHomeViewPresenter!
    private let progressHud : JGProgressHUD = {
       let hud = JGProgressHUD()
       
        hud.textLabel.text = "Downloading"
        hud.detailTextLabel.text = "%0"
        return hud
    }()
    private let homeTableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        table.isScrollEnabled = true
        table.showsVerticalScrollIndicator = false
        return table
    }()
    private let sectionTitles = ["Trending Movies" , "Trending TV" , "Popular" , "Upcoming Movies" , "Top Rated"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.viewDidLoad()
        
    }
 
}
extension HomeViewController : IHomeViewController {
    func showDownloadProgress() {
        progressHud.indicatorView = JGProgressHUDPieIndicatorView()
        progressHud.show(in: view)
        var progress : Float =  0.0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.075
            self.progressHud.setProgress(progress, animated: true)
            let value = progress / 1
            self.progressHud.detailTextLabel.text = "%\(Int(value * 100))"
            if progress > 1 {
                timer.invalidate()
                self.progressHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.progressHud.detailTextLabel.text = nil
                self.progressHud.textLabel.text = "Done!"
                self.progressHud.dismiss(afterDelay: 1.5, animated: true)
            }
        }
    }
    
    func presentError(message : String) {
        DispatchQueue.main.async {
            self.presentAlert(title: "ERROR", message: message)
        }
        
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.homeTableView.reloadData()
        }
    }
    
    func setupNavigationController(){
        let imageView = UIImageView(image: UIImage(named: "netflix-logo"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil) , UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)]
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.isTranslucent = true
    }
    func applyConstraints(){
   
        self.homeTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addSubViews(){
        
        view.addSubview(homeTableView)
    }
}

extension HomeViewController : UITableViewDataSource , UITableViewDelegate{
    func setupTableView(){
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        self.homeTableView.tableHeaderView = HomeTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = self.homeTableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.id, for: indexPath) as? HomeTableViewCell else{
            return UITableViewCell()
        }
        
        cell = HomeTableViewCellRouter.generateModule(cell: cell, homeViewController: self)
        
        let title : Titles
        switch indexPath.section{
        case Titles.trendingMovies.rawValue : 
            title = Titles.trendingMovies
            break
            
        case Titles.trendingTV.rawValue :
            title = Titles.trendingTV
            break
            
        case Titles.popular.rawValue :
            title = Titles.popular
            break
            
        case Titles.upcoming.rawValue :
            title = Titles.upcoming
            break
         
        case Titles.topRated.rawValue :
            title = Titles.topRated
            break
         
        default:
            return UITableViewCell()
        }
        
        Task{
            await presenter.fetchMovies(title: title)
            DispatchQueue.main.async {
                cell.configure(movieList: self.presenter.getMovieList())
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           40
       }
}
