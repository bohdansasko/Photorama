//
//  PhotoStore.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/12/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import Foundation

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
            guard error == nil else {
                print("error fetching interesting photos: \(error!.localizedDescription)")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
                
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let result = self.processPhotosRequest(data: jsonData, error: error)
                print(result)
                completion(result)
            } catch {
                
            }
        }
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
}
