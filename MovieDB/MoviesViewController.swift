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
private let sectionInsets = UIEdgeInsets(top: 15.0, left: 10.0, bottom: 35.0, right: 10.0)

private var context = HomeViewController()
private var movies = [Movie]()
private var page = 1
private var loading = false

final class MoviesViewController: UICollectionView {
    
    func setContext(controller: HomeViewController){
        
        context = controller
        
    }
    
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
                                  vote_average: object["vote_average"] as? Double,
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
    
    func getDate(fromString: String?) -> String?{
        
        if (fromString == nil) { return nil }
        
        let array = fromString!.split(separator: "-")
        // 2019-05-30
        
        let movieRelease = "\(array[2])-\(getMonth(fromString: String(array[1])))-\(array[0])"
        
        return movieRelease
        
    }
    
    func getMonth(fromString: String) -> String{
        
        switch fromString {
        case "01":
            return "Ene"
        case "02":
            return "Feb"
        case "03":
            return "Mar"
        case "04":
            return "Abr"
        case "05":
            return "May"
        case "06":
            return "Jun"
        case "07":
            return "Jul"
        case "08":
            return "Ago"
        case "09":
            return "Sep"
        case "10":
            return "Oct"
        case "11":
            return "Nov"
        case "12":
            return "Dic"
        default:
            return ""
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        context.movies = movies
        context.index = indexPath.item
        context.performSegue(withIdentifier: "showMovieDetails", sender: context)
        
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let path = movies[indexPath.item].poster_path{
            let image = cache.object(forKey: path as NSString)?.image ?? nil
            
            let width = cell.frame.width
            let height = cell.frame.height
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            
            imageView.image = image
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            
            cell.addSubview(imageView)
            
            let detailsLabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.maxY - imageView.frame.height/4, width: imageView.frame.width, height: imageView.frame.height/4))
            let titleBox = UILabel(frame: CGRect(x: 10, y: 10, width: detailsLabel.frame.width - 20, height: detailsLabel.frame.height/2))
            let dateBox = UILabel(frame: CGRect(x: 10, y: titleBox.frame.maxY - 5, width: detailsLabel.frame.width/2, height: detailsLabel.frame.height/2))
            let ratingBox = UILabel(frame: CGRect(x: detailsLabel.frame.maxX - 50, y: titleBox.frame.maxY-5, width: 40, height: detailsLabel.frame.height/2))
            
            detailsLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            titleBox.backgroundColor = .clear
            dateBox.backgroundColor = .clear
            ratingBox.backgroundColor = .clear
            
            detailsLabel.layer.masksToBounds = true
            titleBox.layer.masksToBounds = true
            dateBox.layer.masksToBounds = true
            ratingBox.layer.masksToBounds = true
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.init(name: "Avenir-Black", size: 14)!
            ]
            let detailsAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.init(name: "Avenir-Black", size: 12)!
            ]
            
            let title = NSAttributedString(string: movies[indexPath.item].title ?? "", attributes: titleAttributes)
            let date = NSAttributedString(string: movies[indexPath.item].release_date ?? "", attributes: detailsAttributes)
            let rating = NSAttributedString(string: String(movies[indexPath.item].vote_average ?? 0.0) == "0.0" ? "⭐️ N/A" : "⭐️ " + String(movies[indexPath.item].vote_average!), attributes: detailsAttributes)
            
            titleBox.attributedText = title
            dateBox.attributedText = date
            ratingBox.attributedText = rating
            
            titleBox.numberOfLines = 2
            
            titleBox.sizeToFit()
            
            titleBox.textColor = UIColor.white.withAlphaComponent(0.8)
            dateBox.textColor = UIColor.white.withAlphaComponent(0.8)
            ratingBox.textColor = UIColor.white.withAlphaComponent(0.8)
            
            detailsLabel.addSubview(titleBox)
            detailsLabel.addSubview(dateBox)
            detailsLabel.addSubview(ratingBox)
            imageView.addSubview(detailsLabel)
            
        }
    
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

