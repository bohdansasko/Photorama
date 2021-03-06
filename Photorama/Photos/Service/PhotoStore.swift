//
//  PhotoStore.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/12/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
    
    let imageStore = ImageStore()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores(completionHandler: { description, error in
            if let error = error {
                print("error setting up Core Data (\(error))")
            }
        })
        return container
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
                var result = self.processPhotosRequest(data: jsonData, error: error)
                
                if case .success = result {
                    do {
                        try self.persistentContainer.viewContext.save()
                    } catch {
                        result = .failure(error)
                        print("Core data saving error: \(error.localizedDescription)")
                    }
                }
                
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
        let photoKey = photo.photoID
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            print("===========\(#function)======================")
            if let httpResponse = response as? HTTPURLResponse {
                print("status code: \(httpResponse.statusCode)")
                print("headerFields: \(httpResponse.allHeaderFields)")
            }
            
            let result = self.processImageResult(data: data, error: error)
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        })
        task.resume()
    }
    
    func fetchAllPhotos(completion: @escaping (PhotosResult) -> Void) {
        let fetchRequest: NSFetchRequest<MOPhoto> = MOPhoto.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(keyPath: \MOPhoto.dateTaken,
                                               ascending: true)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let moPhotos = try viewContext.fetch(fetchRequest)
                completion(.success( moPhotos.compactMap({ Photo($0) }) ))
            } catch {
                completion(.failure(error))
            }
        }
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
        return FlickrAPI.photos(fromJSON: jsonData, into: persistentContainer.viewContext)
    }
}
