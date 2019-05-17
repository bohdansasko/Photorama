//
//  PhotoStore.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/12/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import Foundation
import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            print("===========\(#function)======================")
            if let httpResponse = response as? HTTPURLResponse {
                print("status code: \(httpResponse.statusCode)")
                print("headerFields: \(httpResponse.allHeaderFields)")
            }
            
            guard error == nil else {
                print("error fetching interesting photos: \(error!.localizedDescription)")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])                
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let result = self.processPhotosRequest(data: jsonData, error: error)
                OperationQueue.main.addOperation {
                    completion(result)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            print("===========\(#function)======================")
            if let httpResponse = response as? HTTPURLResponse {
                print("status code: \(httpResponse.statusCode)")
                print("headerFields: \(httpResponse.allHeaderFields)")
            }
            
            let result = self.processImageResult(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        })
        task.resume()
    }
    
    private func processImageResult(data: Data?, error: Error?) -> ImageResult {
        guard
            let d = data,
            let downloadedImage = UIImage(data: d) else {
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
            }
        
        return .success(downloadedImage)
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
}
