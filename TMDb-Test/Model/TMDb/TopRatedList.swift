//
//  TopRatedList.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 25/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct TopRatedList {
    var page: Int?
    var total_results: Int?
    var total_pages: Int?
    var results: [TopRatedMovie]?
    
    public init(json: JSON) {
        page = json["page"].int
        total_results = json["total_results"].int
        total_pages = json["total_pages"].int
        let array = json["results"].array!
        for object in array {
            let movie = TopRatedMovie(results: object)
            if (results?.append(movie)) == nil {
                results = [movie]
            }
        }
    }
}

extension API {
    public static func getTopRatedList(page: Int?, completion: @escaping (_ clientReturn: apiReturn, _ data: TopRatedList?) -> ()) -> (){
        var parameter: String = ""
        if let number = page {
            parameter = "&page=\(number)"
        }
            let url  = "https://api.themoviedb.org/3/movie/top_rated"
        networkRequest(url: url, parameter: parameter) { (recieved) in
                var list: TopRatedList?
                if let json = recieved.json {
                    list = TopRatedList(json: json)
                }
                completion(recieved,list)
            }
        }
}

