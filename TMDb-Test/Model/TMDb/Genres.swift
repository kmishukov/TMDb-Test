//
//  Genres.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 26/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Genre {
    let id: Int
    let name: String
    
    public init(jsonGenre: JSON) {
        id = jsonGenre["id"].intValue
        name = jsonGenre["name"].stringValue
    }
}

extension API {
    static var genres: [Genre]?
    static public func getGenres(){
        let url = "https://api.themoviedb.org/3/genre/movie/list"
        let parameter = ""
        networkRequest(url: url, parameter: parameter) { (recieved) in
            if let jsonArray = recieved.json?["genres"].array! {
                var array: [Genre] = []
                for object in jsonArray {
                    let genre = Genre(jsonGenre: object)
                    array.append(genre)
                }
                self.genres = array
            }
        }
    }
    
    static public func genreName(id: [Int]) -> String {
        var genreString: String = ""
        guard let array = genres else { print("Error genres dictionary returned nil."); return "Error" }
        for i in id {
                for object in array {
                    if object.id == i {
                        if genreString != "" {
                            genreString = genreString + ", \(object.name)"
                        } else {
                            genreString = object.name
                        }
                    }
                }
            }
        return genreString
    }
}
