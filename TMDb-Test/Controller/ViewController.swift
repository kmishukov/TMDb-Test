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
    
    @IBOutlet weak var logoVerticalConstraint: NSLayoutConstraint!
    
    let titleLabel = UILabel()
    let logoImage = UIImageView()
    let loginButton = UIButton(type: .system)
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 200, y: 800, width: 50, height: 50), type: .circleStrokeSpin, color: UIColor.textColor)
    
    
    var movieList: MovieList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        view.backgroundColor = UIColor.backgroundColor
        
//        logoImage.translatesAutoresizingMaskIntoConstraints = false
//        logoImage.image = UIImage(named: "movieDbLogo")
////        logoImage.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
//        logoImage.center = view.center
//        logoImage.contentMode = .scaleAspectFit
//        view.addSubview(logoImage)
//        logoImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        logoImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        
        // UILabel: TMDb Test
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "TMDd-Test\nby Mishukov Konstantin"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.textColor? = UIColor.textColor
        titleLabel.alpha = 0
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // UIButton: Login as Guest
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.tintColor = UIColor.textColor
        loginButton.setTitle("Show Top Rated", for: .normal)
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
        self.logoVerticalConstraint.constant = -130
        
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        }) { (bool) in
            UIView.animate(withDuration: 1, animations: {
                self.loginButton.alpha = 1
                self.titleLabel.alpha = 1
            })
        }
  
        
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

