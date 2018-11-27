//
//  ViewController.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 24/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView

let api = API()

class ViewController: UIViewController {
    
    let titleLabel = UILabel()
    let loginButton = UIButton(type: .system)
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 200, y: 800, width: 50, height: 50), type: .circleStrokeSpin, color: UIColor.textColor)
    
    var movieList: TopRatedList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        view.backgroundColor = UIColor.backgroundColor
        
        // UILabel: TMDb Test
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "TMDb Test"
        
        view.addSubview(titleLabel)
        titleLabel.textColor? = UIColor.textColor
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // UIButton: Login as Guest
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.tintColor = UIColor.textColor
        loginButton.setTitle("Top Rated", for: .normal)
        loginButton.setTitleColor(UIColor.textColor, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.textColor.cgColor
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor.backgroundColor
        loginButton.addTarget(self, action: #selector(showTopRated), for: .touchUpInside)
        loginButton.alpha = 0
        
        view.addSubview(loginButton)
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 100).isActive = true
        
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor, constant: 100).isActive = true
        
        API.getGenres()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.loginButton.alpha = 1
        })
    }
    
    @objc func showTopRated() {
        indicator.startAnimating()
        API.getTopRatedList(page: nil) { (recieved, list) in
            self.movieList = list
            self.indicator.stopAnimating()
            self.performSegue(withIdentifier: "showTopRated", sender: self.loginButton)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTopRated" {
            let navController = segue.destination as! UINavigationController
            let destination = navController.topViewController as! TopRatedViewController
            if let results = movieList?.results, let page = movieList?.page, let totalPages = movieList?.total_pages, let totalItems = movieList?.total_results {
                destination.moviesArray = results
                destination.currentPage = page
                destination.totalPages = totalPages
                destination.totalItems = totalItems
                indicator.stopAnimating()
            }
        }
    }
}

