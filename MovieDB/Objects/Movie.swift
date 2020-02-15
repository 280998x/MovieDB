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
    let vote_average: Double?
    let title: String?
    let release_date: String?
    let original_language: String?
    let original_title: String?
    let genre_ids: [Int]?
    var genres: [String]?
    let backdrop_path: String?
    let adult: Bool?
    let overview: String?
    let poster_path: String?
    
    init(popularity: Float?,
         id: Int?,
         video: Bool?,
         vote_count: Int?,
         vote_average: Double?,
         title: String?,
         release_date: String?,
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
        self.genres = []
        self.backdrop_path = backdrop_path
        self.adult = adult
        self.overview = overview
        self.poster_path = poster_path
        
        self.getGenres()
        
    }
    
    private mutating func getGenres(){
        
        if self.genre_ids == nil { return }
        
        let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=634b49e294bd1ff87914e7b9d014daed&language=es-MX")
        
        if let data = try? Data(contentsOf: url!){
            if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                if let dictionary = json as? [String: Any] {
                    if let array = dictionary["genres"] as? [Any] {
                        
                        for data in array {
                            
                            let object = data as! [String?:Any?]
                            
                            let id = object["id"] as! Int
                            let genre = object["name"] as! String
                            
                            if (genre_ids?.contains(id) ?? false){
                                
                                genres?.append(genre)
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
}
