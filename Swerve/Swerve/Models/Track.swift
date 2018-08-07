//
//  Track.swift
//  Swerve
//
//  Created by Daniel Harris on 30/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation

struct Track {
    
    let name: String
    let artist: String
    let albumCoverURL: String?
    let id: String
    let url: String
    let spotifyUri: String
    
    init(name: String, artist: String, albumCoverURL: String, id: String, url: String, spotifyUri: String) {
        self.name = name
        self.artist = artist
        self.albumCoverURL = albumCoverURL
        self.id = id
        self.url = url
        self.spotifyUri = spotifyUri
    }
    
    
    init(spotify: JSON){
        self.name = (spotify["track"] as! JSON)["name"] as! String
        self.artist = ((spotify["track"] as! JSON)["artists"] as! [JSON])[0]["name"] as! String
        self.albumCoverURL = (((spotify["track"] as! JSON)["album"] as! JSON)["images"] as! [JSON])[0]["url"] as? String
        self.id = (spotify["track"] as! JSON)["id"] as! String
        self.url = ((spotify["track"] as! JSON)["external_urls"] as! JSON)["spotify"] as! String
        self.spotifyUri = (spotify["track"] as! JSON)["uri"] as! String

    }
    
    
    init(jsonDict: JSON){
        self.name = jsonDict["name"] as! String
        self.artist = (jsonDict["artists"] as! [JSON])[0]["name"] as! String
        self.albumCoverURL = ((jsonDict["album"] as! JSON)["images"] as! [JSON])[0]["url"] as? String
        self.id = jsonDict["id"] as! String
        self.url = (jsonDict["external_urls"] as! JSON)["spotify"] as! String
        self.spotifyUri = jsonDict["uri"] as! String
    }
}

