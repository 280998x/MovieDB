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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = collectionView
        collectionView.dataSource = collectionView
        collectionView.getMovies()
        
    }
    
}
