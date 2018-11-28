//
//  MovieList.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 25/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct MovieList {
    var page: Int?
    var total_results: Int?
    var total_pages: Int?
    var results: [Movie]?
    
    public init(json: JSON) {
        page = json["page"].int
        total_results = json["total_results"].int
        total_pages = json["total_pages"].int
        if let array = json["results"].array {
            for object in array {
                let movie = Movie(results: object)
                if (results?.append(movie)) == nil {
                    results = [movie]
                }
            }
        }
    }
}

extension API {
    public static func getTopRatedList(page: Int?, completion: @escaping (_ clientReturn: apiReturn, _ data: MovieList?) -> ()) -> (){
        var parameter: String = ""
        if let number = page {
            parameter = "&page=\(number)"
        }
        let url  = "https://api.themoviedb.org/3/movie/top_rated"
        networkRequest(url: url, parameter: parameter) { (recieved) in
            var list: MovieList?
            if let json = recieved.json {
                list = MovieList(json: json)
            }
            completion(recieved,list)
        }
    }
    
    public static func getSearchList(searchText: String, page: Int?, completion: @escaping (_ clientReturn: apiReturn, _ data: MovieList?) -> ()) -> (){
        let searchString = searchText.replacingOccurrences(of: " ", with: "%20")
        var parameter: String = "&query=\(searchString)"
        if let number = page {
            parameter = parameter + "&page=\(number)&include_adult=false"
        } else {
            parameter = parameter + "&include_adult=false"
        }
        let url  = "https://api.themoviedb.org/3/search/movie/"
        networkRequest(url: url, parameter: parameter) { (recieved) in
            var list: MovieList?
            if let json = recieved.json {
                list = MovieList(json: json)
            }
            completion(recieved,list)
        }
    }
}


