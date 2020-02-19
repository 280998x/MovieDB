//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Alan on 14/02/20.
//  Copyright © 2020 Alan. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var box: UIScrollView!
    
    let cache = NSCache<NSString,ImageCache>()
    let xSpacing: CGFloat = 20.0
    let ySpacing: CGFloat = 30.0
    let screenWidth =  UIScreen.main.bounds.width
    let screenHeight =  UIScreen.main.bounds.height
    let safeArea = UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0))
    
    
    var backdrop_path: String = ""
    var movieTitle:String = ""
    var runtime: String = ""
    var release_date: String = ""
    var vote_average: Double = 0.0
    var genres: [String] = [""]
    var overview: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController!.navigationBar
        let navItem = UINavigationItem()
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Regresar", style: .plain, target: self, action: #selector(dismissView))
        navItem.title = "Información"
        
        nav.items = [navItem]
        
        nav.prefersLargeTitles = true
        
        box.frame = safeArea
        
        let headerBox = UIImageView(frame: CGRect(x: 0, y: 0, width: box.frame.width, height: box.frame.width * 0.5))
        let movieTitleBox = UILabel(frame: CGRect(x: xSpacing, y: headerBox.frame.maxY, width: box.frame.width - xSpacing, height: 130))
        let runtimeBox = UILabel(frame: CGRect(x: xSpacing, y: movieTitleBox.frame.maxY, width: box.frame.width - 10, height: ySpacing))
        let runtimeDescriptionBox = UILabel(frame: CGRect(x: xSpacing, y: runtimeBox.frame.maxY, width: 0, height: 0))
        let release_dateBox = UILabel(frame: CGRect(x: xSpacing, y: runtimeDescriptionBox.frame.maxY + ySpacing, width: box.frame.width - 10, height: ySpacing))
        let release_dateDescriptionBox = UILabel(frame: CGRect(x: xSpacing, y: release_dateBox.frame.maxY, width: 0, height: 0))
        let vote_averageBox = UILabel(frame: CGRect(x: xSpacing, y: release_dateDescriptionBox.frame.maxY + ySpacing, width: box.frame.width - 10, height: ySpacing))
        let vote_averageDescriptionBox = UILabel(frame: CGRect(x: xSpacing, y: vote_averageBox.frame.maxY, width: 0, height: 0))
        let genresBox = UILabel(frame: CGRect(x: xSpacing, y: vote_averageDescriptionBox.frame.maxY + ySpacing, width: box.frame.width - 10, height: ySpacing))
        let genresDescriptionBox = UILabel(frame: CGRect(x: xSpacing, y: genresBox.frame.maxY, width: box.frame.width, height: 0))
        let overviewBox = UILabel(frame: CGRect(x: xSpacing, y: genresDescriptionBox.frame.maxY + ySpacing, width: box.frame.width - 10, height: ySpacing))
        let overviewDescriptionBox = UILabel(frame: CGRect(x: xSpacing, y: overviewBox.frame.maxY, width: box.frame.width - 40, height: 200))
        
        let bigTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.init(name: "Avenir-Black", size: 25)!
        ]
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.init(name: "Avenir-Black", size: 20)!
        ]
        let descriptionAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.init(name: "Avenir", size: 16)!
        ]
        
        DispatchQueue.global(qos: .userInteractive).async{
                    
            if self.cache.object(forKey: self.backdrop_path as NSString) == nil{
                            
                let base = "https://image.tmdb.org/t/p/w500/"
                let url = URL(string: base.appending(self.backdrop_path))
                let imageToCache: UIImage
                    
                let data = try? Data(contentsOf: url!)
                let cacheImage = ImageCache()
                
                if data != nil {
                    
                    imageToCache =  UIImage(data: data!)!
                    cacheImage.image = imageToCache
                    
                    self.cache.setObject(cacheImage, forKey: self.backdrop_path as NSString)
                    
                }
                        
            }
            
            DispatchQueue.main.async {
            
                headerBox.image = self.cache.object(forKey: self.backdrop_path as NSString)?.image
                headerBox.layer.masksToBounds = true
                
            }
        }
        
        movieTitleBox.attributedText = NSAttributedString(string: movieTitle, attributes: bigTitleAttributes)
        runtimeBox.attributedText = NSAttributedString(string: "Duración", attributes: titleAttributes)
        runtimeDescriptionBox.attributedText = NSAttributedString(string: runtime, attributes: descriptionAttributes)
        release_dateBox.attributedText = NSAttributedString(string: "Fecha de estreno", attributes: titleAttributes)
        release_dateDescriptionBox.attributedText = NSAttributedString(string: release_date, attributes: descriptionAttributes)
        vote_averageBox.attributedText = NSAttributedString(string: "Calificación", attributes: titleAttributes)
        vote_averageDescriptionBox.attributedText = NSAttributedString(string: String(vote_average) == "0.0" ? "N/A" : String(vote_average), attributes: descriptionAttributes)
        genresBox.attributedText = NSAttributedString(string: "Géneros", attributes: titleAttributes)
        genresDescriptionBox.attributedText = NSAttributedString(string: genres.description.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: ""), attributes: descriptionAttributes)
        overviewBox.attributedText = NSAttributedString(string: "Descripción", attributes: titleAttributes)
        overviewDescriptionBox.attributedText = NSAttributedString(string: overview, attributes: descriptionAttributes)
        
        movieTitleBox.numberOfLines = 4
        genresDescriptionBox.numberOfLines = 2
        overviewDescriptionBox.numberOfLines = 20
        
        runtimeDescriptionBox.sizeToFit()
        release_dateDescriptionBox.sizeToFit()
        vote_averageDescriptionBox.sizeToFit()
        genresDescriptionBox.sizeToFit()
        overviewDescriptionBox.sizeToFit()
        
        box.addSubview(headerBox)
        box.addSubview(movieTitleBox)
        box.addSubview(runtimeBox)
        box.addSubview(runtimeDescriptionBox)
        box.addSubview(release_dateBox)
        box.addSubview(release_dateDescriptionBox)
        box.addSubview(vote_averageBox)
        box.addSubview(vote_averageDescriptionBox)
        box.addSubview(genresBox)
        box.addSubview(genresDescriptionBox)
        box.addSubview(overviewBox)
        box.addSubview(overviewDescriptionBox)
        
        box.contentSize = CGSize(width: screenWidth, height: screenHeight + 200)
        
    }
    
    @objc func dismissView(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
