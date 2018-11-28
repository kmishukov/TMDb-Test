//
//  CustomImageView.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 28/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


// TODO imageCaching

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImage(fromURL urlString: String, indicatorType: NVActivityIndicatorType) {
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        let activityView = NVActivityIndicatorView(frame: CGRect(x: 200, y: 800, width: 50, height: 50), type: indicatorType, color: UIColor.textColor)
        self.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityView.startAnimating()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            }
            if error != nil {
                print(error!)
                return
            }
            
            if let data = data {
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    
                    if self.imageUrlString == urlString {
                     self.image = image
                    }
                    
                    imageCache.setObject(image!, forKey: urlString as AnyObject)

                }
            }
        }.resume()
    }
}
