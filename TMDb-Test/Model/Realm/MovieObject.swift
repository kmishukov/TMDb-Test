//
//  MovieObject.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 27/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation
import RealmSwift

public class MovieObject: Object {
    @objc dynamic var vote_count = 0
    @objc dynamic var id = 0
    @objc dynamic var video = false
    @objc dynamic var vote_average: Float = 0.0
    @objc dynamic var title = ""
    @objc dynamic var popularity: Float = 0.0
    @objc dynamic var poster_path = ""
    @objc dynamic var original_language = ""
    @objc dynamic var original_title = ""
    let genre_ids = List<Int>()
    @objc dynamic var backdrop_path = ""
    @objc dynamic var adult = false
    @objc dynamic var overview = ""
    @objc dynamic var release_date = ""
 
    convenience init(movie: TopRatedMovie) {
        self.init()
        vote_count = movie.vote_count ?? 0
        id = movie.id ?? 0
        video = movie.video ?? false
        vote_average = movie.vote_average ?? 0.0
        title = movie.title ?? ""
        popularity = movie.popularity ?? 0.0
        poster_path = movie.poster_path ?? ""
        original_language = movie.original_language ?? ""
        original_title = movie.original_title ?? ""
            for item in movie.genre_ids {
                self.genre_ids.append(item)
            }
        backdrop_path = movie.backdrop_path ?? ""
        adult = movie.adult ?? false
        overview = movie.overview ?? ""
        release_date = movie.release_date ?? ""
    }
}

