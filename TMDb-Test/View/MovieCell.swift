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

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        posterImage.image = nil
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
