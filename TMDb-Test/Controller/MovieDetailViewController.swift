//
//  MovieDetailViewController.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 26/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import RealmSwift

class MovieDetailViewController: UIViewController {
    
    var movie: TopRatedMovie?
    var realm = try! Realm()
    
    let posterImage = UIImageView()
    let maintitle = UILabel()
    let origTitle = UILabel()
    let genre = UILabel()
     let popularity = UILabel()
    let rating = UILabel()
    let release_date = UILabel()
    let overview = UILabel()
    let favouriteButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        checkFavourites()
    }
    
    // Весь User Interface написан программно
    
    func configureView(){
        navigationController?.navigationBar.setBottomBorderColor(color: UIColor.textColor, height: 1.0)
        view.backgroundColor = UIColor.backgroundColor
        
        
        posterImage.frame = CGRect(x: 15, y: 20, width: 200, height: 300)
        view.addSubview(posterImage)
        if let posterPath = movie?.poster_path {
            let loadPath = "https://image.tmdb.org/t/p/w500/" + posterPath
            posterImage.loadImage(fromURL: loadPath, indicatorType: .ballTrianglePath)
            
        }
        
        
        maintitle.translatesAutoresizingMaskIntoConstraints = false
        maintitle.textColor = UIColor.textColor
        maintitle.numberOfLines = 0
        maintitle.font = UIFont.boldSystemFont(ofSize: 18)
        maintitle.text = movie?.title
        view.addSubview(maintitle)
        maintitle.topAnchor.constraint(equalTo: posterImage.topAnchor, constant: 0).isActive = true
        maintitle.leftAnchor.constraint(equalTo: posterImage.rightAnchor, constant: 10).isActive = true
        maintitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        origTitle.translatesAutoresizingMaskIntoConstraints = false
        origTitle.textColor = UIColor.textColor
        origTitle.numberOfLines = 0
        origTitle.font = UIFont.italicSystemFont(ofSize: 15)
        origTitle.text = movie?.original_title
        view.addSubview(origTitle)
        origTitle.topAnchor.constraint(equalTo: maintitle.bottomAnchor, constant: 0).isActive = true
        origTitle.leftAnchor.constraint(equalTo: posterImage.rightAnchor, constant: 10).isActive = true
        origTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        let boldTextAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16) ]
        
        
        genre.translatesAutoresizingMaskIntoConstraints = false
        genre.textColor = UIColor.textColor
        genre.numberOfLines = 0
        genre.font = UIFont.systemFont(ofSize: 15)
        if let genreIDs = movie?.genre_ids {
            let genreString = API.genreName(id: genreIDs)
            let myString = NSMutableAttributedString(string: "Genres:", attributes: boldTextAttribute)
            myString.append(NSAttributedString(string: " \(genreString)"))
            genre.attributedText = myString
        } else {
            print("Error: genre_ids value returned nil.")
            genre.text = "Genres: Error"
        }
        view.addSubview(genre)
        genre.topAnchor.constraint(equalTo: origTitle.bottomAnchor, constant: 15).isActive = true
        genre.leftAnchor.constraint(equalTo: posterImage.rightAnchor, constant: 10).isActive = true
        genre.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
       
        popularity.translatesAutoresizingMaskIntoConstraints = false
        popularity.textColor = UIColor.textColor
        popularity.numberOfLines = 0
        popularity.font = UIFont.systemFont(ofSize: 15)
        if let value = movie?.popularity {
            let myString = NSMutableAttributedString(string: "Popularity:", attributes: boldTextAttribute)
            myString.append(NSAttributedString(string: " \(value)"))
            popularity.attributedText = myString
        } else {
            print("Error: popularity value returned nil.")
            popularity.text = "Popularity: Error"
        }
        view.addSubview(popularity)
        popularity.topAnchor.constraint(equalTo: genre.bottomAnchor, constant: 0).isActive = true
        popularity.leftAnchor.constraint(equalTo: posterImage.rightAnchor, constant: 10).isActive = true
        popularity.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        rating.translatesAutoresizingMaskIntoConstraints = false
        rating.textColor = UIColor.textColor
        rating.numberOfLines = 0
        rating.font = UIFont.systemFont(ofSize: 15)
        if let value = movie?.vote_average {
            let myString = NSMutableAttributedString(string: "Rating:", attributes: boldTextAttribute)
            myString.append(NSAttributedString(string: " \(value)"))
            rating.attributedText = myString
        } else {
            print("Error: vote_average value returned nil.")
            rating.text = "Rating: Error"
        }
        view.addSubview(rating)
        rating.topAnchor.constraint(equalTo: popularity.bottomAnchor, constant: 0).isActive = true
        rating.leftAnchor.constraint(equalTo: posterImage.rightAnchor, constant: 10).isActive = true
        rating.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        release_date.translatesAutoresizingMaskIntoConstraints = false
        release_date.textColor = UIColor.textColor
        release_date.numberOfLines = 0
        release_date.font = UIFont.systemFont(ofSize: 15)
        if let value = movie?.release_date {
            let myString = NSMutableAttributedString(string: "Release date:", attributes: boldTextAttribute)
            let valueString = value.toDate()
            myString.append(NSAttributedString(string: "\n\(valueString)"))
            release_date.attributedText = myString
        } else {
            print("Error: release_date value returned nil.")
            release_date.text = "Release date: Error"
        }
        view.addSubview(release_date)
        release_date.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 0).isActive = true
        release_date.leftAnchor.constraint(equalTo: posterImage.rightAnchor, constant: 10).isActive = true
        release_date.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        overview.translatesAutoresizingMaskIntoConstraints = false
        overview.textColor = UIColor.textColor
        overview.numberOfLines = 0
        overview.font = UIFont.systemFont(ofSize: 16)
        overview.text = movie?.overview
        overview.textAlignment = .justified
        view.addSubview(overview)
        overview.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 10).isActive = true
        overview.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor, constant: 0).isActive = true
        overview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.setTitle("Set to Favourites", for: .normal)
        favouriteButton.setTitleColor(UIColor.textColor, for: .normal)
        favouriteButton.backgroundColor = UIColor.backgroundColor
        favouriteButton.layer.borderWidth = 2
        favouriteButton.layer.borderColor = UIColor.textColor.cgColor
        favouriteButton.layer.cornerRadius = 5
        favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        view.addSubview(favouriteButton)
        favouriteButton.centerYAnchor.constraint(equalTo: overview.bottomAnchor, constant: 75).isActive = true
        favouriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        favouriteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        favouriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        favouriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
    }
    
    func checkFavourites(){
        guard let id = self.movie?.id else { print("Error: self.movie?.id returned nil."); return }
        if realm.objects(MovieObject.self).filter("id == \(id)").count == 0 {
            favouriteButton.layer.borderColor = UIColor.textColor.cgColor
            favouriteButton.setTitleColor(UIColor.textColor, for: .normal)
            favouriteButton.setTitle("Add to favourites", for: .normal)
            favouriteButton.tag = 0
        } else {
            favouriteButton.layer.borderColor = UIColor.red.cgColor
            favouriteButton.setTitleColor(UIColor.red, for: .normal)
            favouriteButton.setTitle("Remove from favourites", for: .normal)
            favouriteButton.tag = 1
        }
    }
    
    @objc func favouriteButtonPressed() {
        switch favouriteButton.tag {
        case 0:
            try! realm.write {
                guard let mov = movie else { return }
                let movieObj = MovieObject(movie: mov)
                realm.add(movieObj)
            }
            UIView.animate(withDuration: 2) {
                self.checkFavourites()
            }
        default:
            guard let id = self.movie?.id else { print("Error: self.movie?.id returned nil."); return }
            let result = realm.objects(MovieObject.self).filter("id == \(id)")
            try! realm.write {
                realm.delete(result)
            }
            UIView.animate(withDuration: 2) {
                self.checkFavourites()
            }
        }
       
    }
}
