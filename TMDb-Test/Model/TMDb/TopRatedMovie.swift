//
//  TopRatedMovie.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 25/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

public struct TopRatedMovie {
    var vote_count: Int?
    var id: Int?
    var video: Bool?
    var vote_average: Float?
    var title: String?
    var popularity: Float?
    var poster_path: String?
    var original_language: String?
    var original_title: String?
    var genre_ids: [Int] = []
    var backdrop_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    
    public init(results: JSON) {
        vote_count = results["vote_count"].int
        id = results["id"].int
        video = results["video"].bool
        vote_average = results["vote_average"].float
        title = results["title"].string
        popularity = results["popularity"].float
        poster_path = results["poster_path"].string
        original_language = results["original_language"].string
        original_title = results["original_title"].string
        genre_ids = results["genre_ids"].arrayValue.map({$0.intValue})
        backdrop_path = results["backdrop_path"].stringValue
        adult = results["adult"].bool
        overview = results["overview"].string
        release_date = results["release_date"].string
    }
    
    public init(mObject: MovieObject) {
        vote_count = mObject.vote_count
        id = mObject.id
        video = mObject.video
        vote_average = mObject.vote_average
        title = mObject.title
        popularity = mObject.popularity
        poster_path = mObject.poster_path
        original_language = mObject.original_language
        original_title = mObject.original_title
        let count = mObject.genre_ids.count
        for i in 0...count-1 {
            genre_ids.append(mObject.genre_ids[i])
        }
//        genre_ids?.append(contentsOf: mObject.genre_ids)
        backdrop_path = mObject.backdrop_path
        adult = mObject.adult
        overview = mObject.overview
        release_date = mObject.release_date
    }
}
