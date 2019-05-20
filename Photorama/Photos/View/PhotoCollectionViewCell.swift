//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/18/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }
    
    func update(with image: UIImage?) {
        if let imgToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imgToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        print(#function)
        super.apply(layoutAttributes)
        
        layer.anchorPoint = CGPoint(x: 0, y: 0.5)
    }
}
