//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/12/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var store: PhotoStore!
    var photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = photoDataSource
        
        store.fetchInterestingPhotos { photosResult in
            switch photosResult {
            case .success(let photos):
                print("successfully found \(photos.count) photos")
                self.photoDataSource.photos = photos
            case .failure(let error):
                print("Error fetching interesting photos: \(error.localizedDescription)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}

