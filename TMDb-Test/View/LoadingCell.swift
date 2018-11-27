//
//  LoadingCell.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 27/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingCell: UITableViewCell {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 200, y: 800, width: 20, height: 20), type: .lineScale, color: UIColor.textColor)
    let loadingLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = UIColor.backgroundColor
        
        loadingLabel.text = "Loading.."
        loadingLabel.textColor = UIColor.textColor
        self.contentView.addSubview(loadingLabel)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -20).isActive = true

        self.contentView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 10).isActive = true
        indicator.startAnimating()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
