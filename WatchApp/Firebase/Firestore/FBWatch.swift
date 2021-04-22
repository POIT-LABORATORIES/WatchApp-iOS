//
//  FBWatch.swift
//  WatchApp
//
//  Created by kirill on 27.03.2021.
//

import Foundation
import CoreLocation
import SwiftUI

struct FBWatch: Identifiable {
    var id: String = ""
    var name: String = ""
    var style: String = ""
    var caseMaterial: String = ""
    var caseColor: String = ""
    var description: String = ""
    var avatarUrl: String = ""
    var avatar: UIImage = UIImage()
    var latitude: Double = 0
    var longitude: Double = 0
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    init(){}
    
    init(id: String, name: String, style: String, caseMaterial: String, caseColor: String, description: String, avatarUrl: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.style = style
        self.caseMaterial = caseMaterial
        self.caseColor = caseColor
        self.description = description
        self.avatarUrl = avatarUrl
        self.latitude = latitude
        self.longitude = longitude
    }
}


extension FBWatch {
    init?(documentData: [String : Any]) {
        let id = documentData[FBKeys.Watch.id] as? String ?? ""
        let name = documentData[FBKeys.Watch.name] as? String ?? ""
        let style = documentData[FBKeys.Watch.style] as? String ?? ""
        let caseMaterial = documentData[FBKeys.Watch.caseMaterial] as? String ?? ""
        let caseColor = documentData[FBKeys.Watch.caseColor] as? String ?? ""
        let description = documentData[FBKeys.Watch.description] as? String ?? ""
        let avatarUrl = documentData[FBKeys.Watch.avatarUrl] as? String ?? ""
        let latitude = documentData[FBKeys.Watch.latitude] as? Double ?? 0
        let longitude = documentData[FBKeys.Watch.longitude] as? Double ?? 0
        
        self.init(id: id, name: name, style: style, caseMaterial: caseMaterial, caseColor: caseColor, description: description, avatarUrl: avatarUrl, latitude: latitude, longitude: longitude)
    }
    
    func dataDict() -> [String: Any] {
        var data: [String: Any] = [:]
        
        if self.name != "" {
            data = [
                FBKeys.Watch.id: self.id,
                FBKeys.Watch.name: self.name,
                FBKeys.Watch.style: self.style,
                FBKeys.Watch.caseMaterial: self.caseMaterial,
                FBKeys.Watch.caseColor: self.caseColor,
                FBKeys.Watch.description: self.description,
                FBKeys.Watch.avatarUrl: self.avatarUrl,
                FBKeys.Watch.latitude: self.latitude,
                FBKeys.Watch.longitude: self.longitude
            ]
        }
        return data
    }
}
