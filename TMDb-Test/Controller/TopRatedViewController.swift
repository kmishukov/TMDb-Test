//
//  TopRatedViewController.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 27/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TopRatedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var customSearchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var totalItems: Int = 0
    var currentPage: Int = 0
    var totalPages: Int = 0
    var moviesArray: [TopRatedMovie] = []
    var searchResultsArray: [TopRatedMovie]  = []
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSearchBar()
    }
    
    func configureView() {
        navigationController?.navigationBar.setBottomBorderColor(color: UIColor.textColor, height: 1.0)
        view.backgroundColor = UIColor.backgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.textColor
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.tableFooterView = UIView()
        
        customSearchBar.delegate = self
        
        let banner = UIImageView(image: UIImage(named: "banner"))
        banner.frame = CGRect(x: view.frame.size.width/2 - 100, y: -100, width: 200, height: 50)
        banner.contentMode = .scaleAspectFill
        tableView.addSubview(banner)
    }
    
    func configureSearchBar(){
        customSearchBar.delegate = self
        customSearchBar.returnKeyType = .search
        customSearchBar.autocapitalizationType = .sentences
        customSearchBar.tintColor = UIColor.textColor
        customSearchBar.backgroundColor = UIColor.backgroundColor
        customSearchBar.clearButtonMode = .always
        customSearchBar.layer.borderWidth = 1
        customSearchBar.layer.borderColor = UIColor.textColor.cgColor
        customSearchBar.layer.cornerRadius = 5
        customSearchBar.setClearButtonColor(color: UIColor.textColor)
        customSearchBar.attributedPlaceholder = NSAttributedString(string: "Search..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textColor])
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.currentPage == self.totalPages || self.totalItems == moviesArray.count) {
            return moviesArray.count
        }
        return moviesArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.moviesArray.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopRatedMovieCell
            
            if let title = moviesArray[indexPath.row].title {
                cell.titleLabel.textColor = UIColor.textColor
                cell.titleLabel.text = title
            }
            if let originalTitle = moviesArray[indexPath.row].original_title {
                cell.originalTitleLabel.textColor = UIColor.textColor
                cell.originalTitleLabel.text = originalTitle
            }
            
            cell.posterImage.image = UIImage(named: "placeholder")
            if let posterPath = moviesArray[indexPath.row].poster_path {
                let loadPath = "https://image.tmdb.org/t/p/w200/" + posterPath
                cell.posterImage.loadImage(fromURL: loadPath, indicatorType: .ballSpinFadeLoader)
            }
            
            if let overview = moviesArray[indexPath.row].overview {
                cell.overviewLabel.textColor = UIColor.textColor
                cell.overviewLabel.text = overview
            }
            
            if let voteAvrg = moviesArray[indexPath.row].vote_average {
                cell.voteAverage.textColor = UIColor.textColor
                cell.voteAverage.text = "Vote average: \(voteAvrg)"
            }
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = UIColor.backgroundColor
            
            return cell
    
        }
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == moviesArray.count - 1 {
            self.loadMoreMovies(page: self.currentPage + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    // MARK: UITextField Delegates
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        customSearchBar.resignFirstResponder()
        customSearchBar.text = ""
        customSearchBar.placeholder = "Search.."
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return from textfield!")
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexpath = tableView.indexPathForSelectedRow {
                let selection = indexpath.row
//                let nav = segue.destination as! UINavigationController
//                let destination = nav.topViewController as! MovieDetailViewController
                let destination = segue.destination as! MovieDetailViewController
                destination.movie = moviesArray[selection]
            }
        }
    }
    
    func loadMoreMovies(page: Int?) {
        API.getTopRatedList(page: page) { (apiReturn, list) in

            guard let results = list?.results else { return }
            guard let currentPage = list?.page else { return }
            guard let totalPages = list?.total_pages else { return }
            guard let totalItems = list?.total_results else { return }
            
            self.currentPage = currentPage
            self.totalPages = totalPages
            self.totalItems = totalItems
            self.moviesArray.append(contentsOf: results)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        API.getTopRatedList(page: nil) { (apireturn, list) in
            if let results = list?.results {
                self.moviesArray = results
                self.tableView.reloadData()
            }
        }
    }
}
extension UITextField {
    func setClearButtonColor(color: UIColor) {
        let clearButton = self.value(forKey: "_clearButton") as? UIButton
        if (clearButton != nil) {
            let image = UIImage(named: "clearButton")?.withRenderingMode(.alwaysTemplate)
            clearButton?.setImage(image, for: .normal)
            clearButton?.setImage(image, for: .highlighted)
            clearButton?.tintColor = color
        }
    }
}

extension UITableView {
    func reloadDataAfterDelay(delayTime: TimeInterval = 0.5) -> Void {
        self.perform(#selector(self.reloadData), with: nil, afterDelay: delayTime)
    }
}
