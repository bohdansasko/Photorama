//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/12/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import Foundation

enum FlickrError: Error {
    case invalidJSONData
}

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
    case recentPhotos = "flickr.photos.getRecent"
}

extension DateFormatter {
    static let flick: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}

struct FlickrAPI {
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos,
                         parameters: ["extras": "url_s,date_taken"])
    }
    
    private static let kBaseURLString = "https://api.flickr.com/services/rest"
    private static let kApiKey = "a6d819499131071f158fd740860a5a88"
    
    private static func flickrURL(method: Method,
                                  parameters: [String: String]?) -> URL {
        var components = URLComponents(string: kBaseURLString)!
        var queryItems = [URLQueryItem]()
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": kApiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        guard let additionalParams = parameters else {
            return components.url!
        }
        
        for (key, value) in additionalParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
    
        components.queryItems = queryItems
        print(components)
        return components.url!
    }
    
    static func photos(fromJSON data: Data) -> PhotosResult {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.flick)
            let photos = try decoder.decode(Photos.self, from: data)
            
            if photos.photos.isEmpty {
                return .failure(FlickrError.invalidJSONData)
            }
            
            return .success(photos.photos)
        } catch {
            return .failure(error)
        }
    }
}

