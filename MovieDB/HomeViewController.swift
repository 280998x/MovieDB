//
//  HomeViewController.swift
//  MovieDB
//
//  Created by Alan on 13/02/20.
//  Copyright © 2020 Alan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: MoviesViewController!
    
    var movies: [Movie] = []
    var index: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = collectionView
        collectionView.dataSource = collectionView
        collectionView.setContext(controller: self)
        collectionView.getMovies()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetails"{
            
            let navigationController = segue.destination as! UINavigationController
            let movieDetailsViewController = navigationController.topViewController as! MovieDetailsViewController
            
            movieDetailsViewController.movieTitle = movies[index].title ?? ""
            
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(movies[index].id ?? 0)?api_key=634b49e294bd1ff87914e7b9d014daed&language=es-MX")
            if let data = try? Data(contentsOf: url!){
                if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                    if let dictionary = json as? [String: Any] {
                        
                        movieDetailsViewController.runtime = "\(dictionary["runtime"] ?? "N/A") min"
                    
                    }
                }
            }
            
            movieDetailsViewController.backdrop_path = movies[index].backdrop_path ?? ""
            movieDetailsViewController.release_date = movies[index].release_date ?? ""
            movieDetailsViewController.vote_average = movies[index].vote_average ?? 0.0
            movieDetailsViewController.genres = movies[index].genres ?? [""]
            movieDetailsViewController.overview = movies[index].overview ?? ""
            
        }
    }
}
