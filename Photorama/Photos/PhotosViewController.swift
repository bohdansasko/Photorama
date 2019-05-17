//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/12/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchInterestingPhotos { photosResult in
            switch photosResult {
            case .success(let photos):
                print("successfully found \(photos.count) photos")
                if let fp = photos.first {
                    self.updateImageView(for: fp)
                }
            case .failure(let error):
                print("Error fetching interesting photos: \(error.localizedDescription)")
            }
        }
            
    }

    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo, completion: { result in
            switch result {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }

}

