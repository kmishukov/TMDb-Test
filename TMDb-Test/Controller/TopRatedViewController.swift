//
//  TopRatedViewController.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 27/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RealmSwift
import FaveButton

class TopRatedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  
    @IBOutlet weak var customSearchBar: UITextField!  // Handmade custom SearchBar :)
    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarSuperView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var totalItems: Int = 0
    var currentPage: Int = 0
    var totalPages: Int = 0
    var rowToUpdate: Int?
    var moviesArray: [Movie] = []
    var searchResultsArray: [Movie] = []
    let realm = try! Realm()
    var isSearching: Bool = false { // Animated Search mode on/off
        didSet {
            if isSearching {
                
                self.currentPage = 1
                self.totalPages = 0
                self.totalItems = 0
                
                let fadeTextAnimation = CATransition()
                fadeTextAnimation.duration = 0.5
                fadeTextAnimation.type = CATransitionType.fade
                navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
                navigationItem.title = "Search"
                
                UIView.animate(withDuration: 0.5) {
                    self.navigationItem.leftBarButtonItem?.isEnabled = false
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    self.searchBarTrailingConstraint.constant = 70
                    self.cancelButton.alpha = 1
                    self.view.layoutIfNeeded()
                    DispatchQueue.main.async {
                        self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
                    }
                }
            } else {
                
                let fadeTextAnimation = CATransition()
                fadeTextAnimation.duration = 0.5
                fadeTextAnimation.type = CATransitionType.fade
                navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
                navigationItem.title = "Top Rated Movies"
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.searchBarTrailingConstraint.constant = 8
                    self.cancelButton.alpha = 0
                    self.view.layoutIfNeeded()
                }) { (completed) in
                    if completed {
                        DispatchQueue.main.async {
                           
                            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
                             self.tableView.scroll(to: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let row = self.rowToUpdate {
            let indexPath = IndexPath(row: row-1, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    // ui
    func configureView() {
        navigationController?.navigationBar.setBottomBorderColor(color: UIColor.textColor, height: 1.0)
        view.backgroundColor = UIColor.backgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.textColor
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.tableFooterView = UIView()
        
        let banner = UIImageView(image: UIImage(named: "banner"))
        banner.frame = CGRect(x: view.frame.size.width/2 - 100, y: -100, width: 200, height: 50)
        banner.contentMode = .scaleAspectFill
        tableView.addSubview(banner)
        
    }
    // ui searchbar
    func configureSearchBar(){
        customSearchBar.delegate = self
        customSearchBar.returnKeyType = .done
        customSearchBar.autocapitalizationType = .sentences
        customSearchBar.tintColor = UIColor.textColor
        customSearchBar.backgroundColor = UIColor.backgroundColor
        customSearchBar.clearButtonMode = .always
        customSearchBar.layer.borderWidth = 1
        customSearchBar.layer.borderColor = UIColor.textColor.cgColor
        customSearchBar.layer.cornerRadius = 5
        customSearchBar.setClearButtonColor(color: UIColor.textColor)
        customSearchBar.attributedPlaceholder = NSAttributedString(string: "Search..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textColor])
        searchBarSuperView.setViewBottomBorderColor(color: UIColor.textColor, height: 1.0)
        
        cancelButton.alpha = 0
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.setTitleColor(UIColor.textColor, for: .normal)
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if (self.currentPage == self.totalPages || self.totalItems <= searchResultsArray.count) {
                return searchResultsArray.count
            }
            return searchResultsArray.count + 1
        } else {
            if (self.currentPage == self.totalPages || self.totalItems == moviesArray.count) {
                return moviesArray.count
            }
            return moviesArray.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearching {
            
            if indexPath.row == self.searchResultsArray.count {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopRatedMovieCell
                
               guard searchResultsArray.indices.contains(indexPath.row) else { print("searchResultsArray[indexPath.row] returned nil."); return cell }
                
                let movie = searchResultsArray[indexPath.row]
                
                cell.faveButton.normalColor = UIColor.textColor
                cell.faveButton.addTarget(self, action: #selector(faveButtonPressed), for: .touchUpInside)
                cell.faveButton.tag = indexPath.row
                
                if let id = movie.id {
                    if realm.objects(MovieObject.self).filter("id == \(id)").count == 0 {
                        cell.faveButton.setSelected(selected: false, animated: false)
                    } else {
                        cell.faveButton.setSelected(selected: true, animated: false)
                    }
                }
                
                if let title = movie.title {
                    cell.titleLabel.textColor = UIColor.textColor
                    cell.titleLabel.text = title
                }
                if let originalTitle = movie.original_title {
                    cell.originalTitleLabel.textColor = UIColor.textColor
                    cell.originalTitleLabel.text = originalTitle
                }
                
                cell.posterImage.image = UIImage(named: "placeholder")
                if let posterPath = movie.poster_path {
                    let loadPath = "https://image.tmdb.org/t/p/w200/" + posterPath
                    cell.posterImage.loadImageFromUrl(fromURL: loadPath, indicatorType: .ballSpinFadeLoader)
                }
                
                if let overview = movie.overview {
                    cell.overviewLabel.textColor = UIColor.textColor
                    cell.overviewLabel.text = overview
                }
                
                if let voteAvrg = movie.vote_average {
                    cell.voteAverage.textColor = UIColor.textColor
                    cell.voteAverage.text = "Rating: \(voteAvrg)"
                }
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.backgroundColor = UIColor.backgroundColor
                
                return cell
                
            }
            
        } else {
        
            if indexPath.row == self.moviesArray.count {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopRatedMovieCell
                
                guard moviesArray.indices.contains(indexPath.row) else { print("moviesArray[indexPath.row] returned nil."); return cell }
                
                let movie = moviesArray[indexPath.row]
                
                cell.faveButton.addTarget(self, action: #selector(faveButtonPressed), for: .touchUpInside)
                cell.faveButton.tag = indexPath.row
                
                if let id = movie.id {
                    if realm.objects(MovieObject.self).filter("id == \(id)").count == 0 {
                        cell.faveButton.setSelected(selected: false, animated: false)
                    } else {
                        cell.faveButton.setSelected(selected: true, animated: false)
                    }
                }
                
                if let title = movie.title {
                    cell.titleLabel.textColor = UIColor.textColor
                    cell.titleLabel.text = title
                }
                if let originalTitle = movie.original_title {
                    cell.originalTitleLabel.textColor = UIColor.textColor
                    cell.originalTitleLabel.text = originalTitle
                }
                
                cell.posterImage.image = UIImage(named: "placeholder")
                if let posterPath = movie.poster_path {
                    let loadPath = "https://image.tmdb.org/t/p/w200/" + posterPath
                    cell.posterImage.loadImageFromUrl(fromURL: loadPath, indicatorType: .ballSpinFadeLoader)
                }
                
                if let overview = movie.overview {
                    cell.overviewLabel.textColor = UIColor.textColor
                    cell.overviewLabel.text = overview
                }
                
                if let voteAvrg = movie.vote_average {
                    cell.voteAverage.textColor = UIColor.textColor
                    cell.voteAverage.text = "Rating: \(voteAvrg)"
                }
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.backgroundColor = UIColor.backgroundColor
                
                return cell
        
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isSearching {
            if indexPath.row == searchResultsArray.count - 1 {
                self.searchMoreMovies(page: self.currentPage + 1)
            }
        } else {
            if indexPath.row == moviesArray.count - 1 {
                self.loadMoreMovies(page: self.currentPage + 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customSearchBar.resignFirstResponder()
    }
    
    // MARK: UITextField Delegates
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        customSearchBar.text = ""
        customSearchBar.placeholder = "Search.."
        customSearchBar.becomeFirstResponder()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scroll(to: .top, animated: true)
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchOnlineForTextField()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearching = true
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(searchOnlineForTextField),
            object: customSearchBar)
        self.perform(
            #selector(searchOnlineForTextField),
            with: customSearchBar,
            afterDelay: 0.5)
    }
    
    
    // MARK: FaveButton Delelgate
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
         let index = faveButton.tag
            switch selected {
            case true:
                var movieObj = MovieObject()
                if isSearching {
                    movieObj = MovieObject(movie: searchResultsArray[index])
                } else {
                    movieObj = MovieObject(movie: moviesArray[index])
                }
                try! realm.write {
                            realm.add(movieObj)
                            print("Movie \(movieObj.title) saved.")
                    }
            case false:
                var id = ""
                if isSearching {
                    id = String(searchResultsArray[index].id!)
                } else {
                    id = String(moviesArray[index].id!)
                    
                }
                let result = realm.objects(MovieObject.self).filter("id == \(id)")
                try! realm.write {
                    realm.delete(result)
                    print("Object deleted.")
                }
            }
    }
    
    @objc func faveButtonPressed(sender: FaveButton) {
        let index = sender.tag
        switch sender.isSelected {
        case true:
            var movieObj = MovieObject()
            if isSearching {
                movieObj = MovieObject(movie: searchResultsArray[index])
            } else {
                movieObj = MovieObject(movie: moviesArray[index])
            }
            try! realm.write {
                realm.add(movieObj)
                print("Movie \(movieObj.title) saved.")
            }
        case false:
            var id = ""
            if isSearching {
                id = String(searchResultsArray[index].id!)
            } else {
                id = String(moviesArray[index].id!)
                
            }
            let result = realm.objects(MovieObject.self).filter("id == \(id)")
            try! realm.write {
                realm.delete(result)
                print("Object deleted.")
            }
        }
    }
    
    // API Search function that interacts with tableView
    
    @objc func searchOnlineForTextField() {
        if let text = customSearchBar.text {
            self.isSearching = true
            API.getSearchList(searchText: text, page: nil) { (apiReturn, list) in
                
                guard let results = list?.results else {
                    self.searchResultsArray = []
                    self.currentPage = 0
                    self.totalPages = 0
                    self.totalItems = 0
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    return }
                guard let currentPage = list?.page else { return }
                guard let totalPages = list?.total_pages else { return }
                guard let totalItems = list?.total_results else { return }
                
                self.currentPage = currentPage
                self.totalPages = totalPages
                self.totalItems = totalItems
                
                self.searchResultsArray = results
                
                DispatchQueue.main.async {
                    self.tableView.scroll(to: .top, animated: false)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        customSearchBar.resignFirstResponder()
        isSearching = false
        customSearchBar.text = ""
        customSearchBar.placeholder = "Search.."
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexpath = tableView.indexPathForSelectedRow {
                let selection = indexpath.row
                self.rowToUpdate = selection
                let destination = segue.destination as! MovieDetailViewController
                if isSearching {
                     destination.movie = searchResultsArray[selection]
                } else {
                     destination.movie = moviesArray[selection]
                }
               
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
    
    func searchMoreMovies(page: Int?) {
        API.getSearchList(searchText: customSearchBar.text!, page: page) { (apiReturn, list) in
            guard let results = list?.results else { return }
            guard let currentPage = list?.page else { return }
            guard let totalPages = list?.total_pages else { return }
            guard let totalItems = list?.total_results else { return }
            
            self.currentPage = currentPage
            self.totalPages = totalPages
            self.totalItems = totalItems
            self.searchResultsArray.append(contentsOf: results)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
// Обновление TopRatedMovieList TableView
    @IBAction func refreshButtonPressed(_ sender: Any) {
        API.getTopRatedList(page: nil) { (apireturn, list) in
            if let results = list?.results {
                self.moviesArray = results
                self.tableView.scroll(to: .top, animated: true)
                self.tableView.reloadData()
            }
        }
    }
    
}

// UITextField ClearButton color change
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

// TableView Reload with delay & Scroll Up
extension UITableView {
    func reloadDataAfterDelay(delayTime: TimeInterval = 0.5) -> Void {
        self.perform(#selector(self.reloadData), with: nil, afterDelay: delayTime)
    }
    public func reloadDataMethod(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
    
    func scroll(to: scrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    enum scrollsTo {
        case top,bottom
    }
}
