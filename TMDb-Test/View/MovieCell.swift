//
//  MovieCell.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 26/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import FaveButton

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var faveButton: FaveButton!

    func configure(movie: Movie) {
        if let title = movie.title {
            titleLabel.text = title
        }
        if let origin_title = movie.original_title {
            originalTitleLabel.text = origin_title
        }
        if let overview = movie.overview {
          overviewLabel.text = overview
        }
        if let posterPath = movie.poster_path {
            let loadPath = "https://image.tmdb.org/t/p/w200/" + posterPath
            posterImage.loadImageFromUrl(fromURL: loadPath, indicatorType: .ballBeat)
        }
        if let rating = movie.vote_average {
            voteAverage.text = "Rating: \(rating)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        configureColors()
    }
    
    func configureColors() {
        titleLabel.textColor = UIColor.textColor
        originalTitleLabel.textColor = UIColor.textColor
        overviewLabel.textColor = UIColor.textColor
        voteAverage.textColor = UIColor.textColor
        self.backgroundColor = UIColor.backgroundColor
    }
    
    override func prepareForReuse() {
        posterImage.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
