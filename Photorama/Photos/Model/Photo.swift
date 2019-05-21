//
//  Photo.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/12/19.
//  Copyright © 2019 Vinso. All rights reserved.
//

import Foundation

class Photo: Codable {
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    
    private enum CodingKeys: String, CodingKey {
        case title
        case photoID = "id"
        case dateTaken = "datetaken"
        case remoteUrl = "url_s"
    }

    init(_ moPhoto: MOPhoto) {
        title = moPhoto.title!
        remoteURL = moPhoto.remoteURL! as URL
        photoID = moPhoto.photoID!
        dateTaken = moPhoto.dateTaken! as Date
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        
        let stringURL = try container.decode(String.self, forKey: .remoteUrl)
        remoteURL = URL(string: stringURL)!
        
        photoID = try container.decode(String.self, forKey: .photoID)
        dateTaken = try container.decode(Date.self, forKey: .dateTaken)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(remoteURL, forKey: .remoteUrl)
        try container.encode(photoID, forKey: .photoID)
        try container.encode(dateTaken, forKey: .dateTaken)
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}

class Photos: Decodable {
    let page: Int
    let pages: Int
    let perPage: Int
    let photos: [Photo]
    
    private enum RootCodingKeys: String, CodingKey {
        case photos
    }
    
    private enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perPage = "perpage"
        case photo
    }
    
    required init(from decoder: Decoder) throws {
        let rootRontainer = try decoder.container(keyedBy: RootCodingKeys.self)
        let container = try rootRontainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .photos)
        page = try container.decode(Int.self, forKey: .page)
        pages = try container.decode(Int.self, forKey: .pages)
        perPage = try container.decode(Int.self, forKey: .perPage)
        photos = try container.decode([Photo].self, forKey: .photo)
    }
}
