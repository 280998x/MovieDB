//
//  MoviesViewController.swift
//  MovieDB
//
//  Created by Alan on 12/02/20.
//  Copyright © 2020 Alan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MovieCell"
private let itemsPerRow: CGFloat = 2
private let cache = NSCache<NSString, ImageCache>()
private let spinner = UIActivityIndicatorView(style: .medium)
private let sectionInsets = UIEdgeInsets(top: 25.0, left: 20.0, bottom: 25.0, right: 20.0)

private var movies = [Movie]()
private var page = 1
private var loading = false

final class MoviesViewController: UICollectionView {
    
    @objc func getMovies(){
        
        loading = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            var json: Any?
            let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=634b49e294bd1ff87914e7b9d014daed&language=es-MX&page=\(page)")!
                    
            if let data = try? Data(contentsOf: url){
                
                json = try? JSONSerialization.jsonObject(with: data, options: [])
                
                if let dictionary = json as? [String: Any] {
                    if let array = dictionary["results"] as? [Any] {
                        
                        for data in array {
                            
                            let object = data as! [String?:Any?]
                            
                            let movie = Movie(popularity: object["popularity"] as? Float,
                                  id: object["id"] as? Int,
                                  video: object["video"] as? Bool,
                                  vote_count: object["vote_count"] as? Int,
                                  vote_average: object["vote_average"] as? Float,
                                  title: object["title"] as? String,
                                  release_date: self.getDate(fromString: object["release_date"] as? String),
                                  original_language: object["original_language"] as? String,
                                  original_title: object["original_title"] as? String,
                                  genre_ids: object["genre_ids"] as? [Int],
                                  backdrop_path: object["backdrop_path"] as? String,
                                  adult: object["adult"] as? Bool,
                                  overview: object["overview"] as? String,
                                  poster_path: object["poster_path"] as? String)
                            
                            movies.append(movie)
                            
                        }
                        
                        page += 1
                        self.loadImages()
                        
                    }
                }
            }
            
        }
    }
    
    func getDate(fromString: String?) -> Date?{
        
        if (fromString == nil) { return nil }
        
        let array = fromString!.split(separator: "-")
        // 2019-05-30
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let movieRelease = formatter.date(from: "\(array[0])/\(array[1])/\(array[2])")
        
        return movieRelease
        
    }
    
    func loadImages(){
        
        DispatchQueue.global(qos: .userInteractive).async{
                
            for movie in movies{
                    
                if let path =  movie.poster_path{
                    if cache.object(forKey: path as NSString) == nil{
                        
                        let base = "https://image.tmdb.org/t/p/w500/"
                        let url = URL(string: base.appending(path))
                        let imageToCache: UIImage
                
                        let data = try? Data(contentsOf: url!)
                        let cacheImage = ImageCache()
                
                        imageToCache =  UIImage(data: data!)!
                        cacheImage.image = imageToCache
                
                        cache.setObject(cacheImage, forKey: path as NSString)
                    
                    }
                }
            }
            
            DispatchQueue.main.async {
                
                loading = false
                self.reloadData()
                
            }
            
        }
    }
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return 1
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return movies.count
    
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let path = movies[indexPath.item].poster_path{
            let image = cache.object(forKey: path as NSString)?.image ?? nil
        
            cell.backgroundView = UIImageView(image:image)
            cell.backgroundView?.layer.cornerRadius = 10
            cell.backgroundView?.layer.masksToBounds = true
            
        }
        
        let detailsLabel = UIView(frame: CGRect(x: 0, y: (cell.frame.maxY-100), width: cell.frame.width, height: 100))
        let titleBox = UILabel(frame: CGRect(x: 0, y: 0, width: detailsLabel.frame.width, height: 30))
        
        detailsLabel.addSubview(titleBox)
        cell.addSubview(detailsLabel)
        
        detailsLabel.layer.cornerRadius = 10
        
        detailsLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        titleBox.backgroundColor = .clear
        
        detailsLabel.layer.mask = cell.layer.mask
        titleBox.layer.mask = detailsLabel.layer.mask
        
        detailsLabel.layer.masksToBounds = true
        titleBox.layer.masksToBounds = true
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.init(name: "Avenir-Black", size: 10)
        ]
        
        let title = NSAttributedString(string: movies[indexPath.row].title ?? "", attributes: titleAttributes)
        
        titleBox.attributedText = title
        
        titleBox.textColor = UIColor.white.withAlphaComponent(0.8)
        
        titleBox.textAlignment = .left
    
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (!loading && indexPath.row == movies.count - 1) {
            
            getMovies()
            
        }
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
    
        return CGSize(width: widthPerItem, height: widthPerItem*1.5)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
    return sectionInsets
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
    return sectionInsets.left
    
  }
}

