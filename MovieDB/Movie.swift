//
//  Movie.swift
//  MovieDB
//
//  Created by Alan on 13/02/20.
//  Copyright © 2020 Alan. All rights reserved.
//

import UIKit

struct Movie {
    
    let popularity: Float?
    let id: Int?
    let video: Bool?
    let vote_count: Int?
    let vote_average: Float?
    let title: String?
    let release_date: Date?
    let original_language: String?
    let original_title: String?
    let genre_ids: [Int]?
    let backdrop_path: String?
    let adult: Bool?
    let overview: String?
    let poster_path: String?
    
    init(popularity: Float?,
         id: Int?,
         video: Bool?,
         vote_count: Int?,
         vote_average: Float?,
         title: String?,
         release_date: Date?,
         original_language: String?,
         original_title: String?,
         genre_ids: [Int]?,
         backdrop_path: String?,
         adult: Bool?,
         overview: String?,
         poster_path: String?) {
        
        self.popularity = popularity
        self.id = id
        self.video = video
        self.vote_count = vote_count
        self.vote_average = vote_average
        self.title = title
        self.release_date = release_date
        self.original_language = original_language
        self.original_title = original_title
        self.genre_ids = genre_ids
        self.backdrop_path = backdrop_path
        self.adult = adult
        self.overview = overview
        self.poster_path = poster_path
        
    }
    
}
