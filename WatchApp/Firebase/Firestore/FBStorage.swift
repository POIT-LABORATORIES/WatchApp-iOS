//
//  FBStorage.swift
//  WatchApp
//
//  Created by kirill on 31.03.2021.
//

import Foundation
import FirebaseStorage

struct FBStorage {
    enum FBStoragePath: String {
        case images = "images"
        case videos = "videos"
    }
    
    static func fetchImage(imageUrl: String, handler: @escaping (Data) -> Void) {
        var imageData: Data = Data()
        let imageRef = Storage.storage().reference(forURL: imageUrl)
        imageRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
          if let error = error {
            print()
            print("Cannot download image, message: \(error.localizedDescription)")
            print()
            handler(imageData)
          } else {
            imageData = data!
            handler(imageData)
          }
        }
    }
}
