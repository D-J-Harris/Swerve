//
//  Playlist.swift
//  Swerve
//
//  Created by Daniel Harris on 09/08/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation

struct Playlist {
    
    let name: String
    let creator: String
    let id: String
    let url: String
    let spotifyUri: String
    
    init(name: String, creator: String, id: String, url: String, spotifyUri: String) {
        self.name = name
        self.creator = creator
        self.id = id
        self.url = url
        self.spotifyUri = spotifyUri
    }
    
    
    init(libraryJsonDict: JSON){
        self.name = libraryJsonDict["name"] as! String
        self.creator = (libraryJsonDict["owner"] as! JSON)["id"] as! String
        self.id = libraryJsonDict["id"] as! String
        self.url = (libraryJsonDict["external_urls"] as! JSON)["spotify"] as! String
        self.spotifyUri = libraryJsonDict["uri"] as! String
        
    }
    
    
    init(jsonDict: JSON){
        self.name = jsonDict["name"] as! String
        self.creator = (jsonDict["owner"] as! JSON)["id"] as! String
        self.id = jsonDict["id"] as! String
        self.url = (jsonDict["external_urls"] as! JSON)["spotify"] as! String
        self.spotifyUri = jsonDict["uri"] as! String
    }
}
