//
//  ImageCache.swift
//  Test
//
//  Created by Alan on 2/1/20.
//  Copyright © 2020 Alan. All rights reserved.
//

import UIKit

class ImageCache: NSObject , NSDiscardableContent {

    public var image: UIImage!

    func beginContentAccess() -> Bool {
        return true
    }

    func endContentAccess() {

    }

    func discardContentIfPossible() {

    }

    func isContentDiscarded() -> Bool {
        return false
    }
    
}
