//
//  Configuration.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 25/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation
import SwiftyJSON


// Was not implemented, since there is no need for authorization.

public struct Configuration {
    var base_url: String?
    var secure_base_url: String?
    var backdrop_sizes: [String]?
    var logo_sizes: [String]?
    var poster_sizes: [String]?
    var profile_sizes: [String]?
    var still_sizes: [String]?
    var change_keys: [String]?

    public init(results: JSON) {
        let images = results["images"]
        base_url = images["base_url"].string
        secure_base_url = images["secure_base_url"].string
        backdrop_sizes = images["backdrop_sizes"].arrayObject as? [String]
        logo_sizes = images["logo_sizes"].arrayObject as? [String]
        poster_sizes = images["poster_sizes"].arrayObject as? [String]
        profile_sizes = images["profile_sizes"].arrayObject as? [String]
        still_sizes = images["still_sizes"].arrayObject as? [String]
        change_keys = images["change_keys"].arrayObject as? [String]
    }
}
