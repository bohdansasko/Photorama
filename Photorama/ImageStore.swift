//
//  ImageStore.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/18/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import UIKit

class ImageStore {
    private var cache = NSCache<AnyObject, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imgFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imgFromDisk, forKey: key as NSString)
        
        return imgFromDisk
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDir = documentsDirs.first!
        return documentDir.appendingPathComponent(key)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        
        if let data = image.jpegData(compressionQuality: 0.5) {
            let _ = try? data.write(to: url, options: [.atomic])
        }
    }
    
    func deleteImage(for key: String) {
        cache.removeObject(forKey: key as NSString)
        let url = imageURL(forKey: key)
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error.localizedDescription)")
        }
    }
}
