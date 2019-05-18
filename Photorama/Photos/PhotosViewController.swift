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
        collectionView.delegate = self
        
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

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        store.fetchImage(for: photo, completion: { [photo](result) in
            
            guard
                let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result
            else {
                return
            }
            
            let photoIdxPath = IndexPath(item: photoIndex, section: 0)
            if let cell = self.collectionView.cellForItem(at: photoIdxPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        })
    }
}
