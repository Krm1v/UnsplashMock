//
//  PhotoModel.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 27.06.2022.
//

import Foundation

struct PhotoModel: Codable {
    
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Codable {
    
    let width: Int
    let height: Int
    let urls: [URLVersion.RawValue:String]
    
    enum URLVersion: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
