//
//  Artists.swift
//  Fuzzy Test
//
//  Created by Michael Isasi on 1/13/20.
//  Copyright © 2020 Michael Isasi. All rights reserved.
//

import Foundation

public struct Artists {
    public static let shared = Artists.init()
    
    public let artists:[String]
    
    private init() {
        let url = Bundle.main.url(forResource: "Artists", withExtension: "plist")!
        let artistsData = try! Data(contentsOf: url)
        self.artists = try! PropertyListSerialization.propertyList(from: artistsData, options: [], format: nil) as! [String]
    }
}
