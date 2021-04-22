//
//  FBImage.swift
//  WatchApp
//
//  Created by kirill on 31.03.2021.
//

import Foundation
import SwiftUI
import FirebaseStorage

class FBImage: ObservableObject {
    @Published var dataIsLoaded: Bool = false
    @Published var image: UIImage? = nil
    
    
    // randomimage.jpg
    static func uploadImage(image: UIImage, imageName: String, handler: @escaping ((String) -> Void)) {
        if let imageData = image.jpegData(compressionQuality: 1) {
            let imageRef = Storage.storage().reference().child("\(FBStorage.FBStoragePath.images)/\(imageName)")
            imageRef.putData(imageData, metadata: nil) { (metadata, err) in
                if let err = err {
                    print("Error while uploading image to firebase, message -> \(err.localizedDescription)")
                } else {
                    print("Image uploaded successfully. Metadata: \(metadata?.name), \(metadata?.size), \(metadata?.contentType)")
                    
                    imageRef.downloadURL{ (url, err) in
                        if let err = err {
                            print("Error getting image URL, message: \(err.localizedDescription)")
                        } else {
                            handler(url!.absoluteString)
                        }
                    }
                }
            }
        } else {
            print("Couldn't unwrap image to data")
        }
        
        //return imageUrl
        //return imageName
    }
    
    static func downloadImage(name: String) -> UIImage {
        let imageRef = Storage.storage().reference().child("\(FBStorage.FBStoragePath.images)/\(name)")
        var downloadedimage: UIImage?
        imageRef.getData(maxSize: 15 * 1024 * 1024) { (imageData, err) in
            if let err = err {
                print("Error while downloading image from firebase, message -> \(err.localizedDescription)")
            } else {
                if let imageData = imageData {
                    downloadedimage = UIImage(data: imageData)
                } else {
                    print("Couldn't unwrap image data after downloading it")
                }
            }
        }
        return downloadedimage ?? UIImage()
    }
    
    static func downloadImageFromUrl(url: String) -> UIImage {
        let imageRef = Storage.storage().reference().child("\(FBStorage.FBStoragePath.images)/\(url)")
        var image: UIImage?
        imageRef.getData(maxSize: 15 * 1024 * 1024) { (imageData, err) in
            if let err = err {
                print("Error while downloading image from firebase, message -> \(err.localizedDescription)")
            } else {
                if let imageData = imageData {
                    image = UIImage(data: imageData)
                } else {
                    print("Couldn't unwrap image data after downloading it")
                }
            }
        }
        return image ?? UIImage()
    }
    
    func loadImage(url: String) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
                                                              
            DispatchQueue.main.async {
                self.image = UIImage(data: content)
                self.dataIsLoaded = true
            }
            print("Data loaded")
            
        }
        task.resume()
    }
}
