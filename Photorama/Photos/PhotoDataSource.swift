//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/17/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    var photos = [Photo]()
    let kImageCellName = "PhotoCollectionViewCell"

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kImageCellName, for: indexPath) as! PhotoCollectionViewCell
        return cell
    }
}
