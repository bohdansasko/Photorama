//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/19/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        store.fetchImage(for: photo, completion: { result in
            switch result {
            case .success(let image):
                self.imageView.image = image
            case .failure(let err):
                print("Error fetching image for photo \(err.localizedDescription)")
            }
        })
    }
}
