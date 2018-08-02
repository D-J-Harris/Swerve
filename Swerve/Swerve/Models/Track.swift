//
//  Track.swift
//  Swerve
//
//  Created by Daniel Harris on 30/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Track {
    let name: String
    let artist: String
    let album: String
    let id: String
    let url: String
    let spotifyUri: String
    
    init(name: String, artist: String, album: String, id: String, url: String, spotifyUri: String) {
        self.name = name
        self.artist = artist
        self.album = album
        self.id = id
        self.url = url
        self.spotifyUri = spotifyUri
    }
    
    init(json: JSON, _ i: Int){
        self.name = json["items"][i]["track"]["name"].stringValue
        self.artist = json["items"][i]["track"]["artists"]["name"].stringValue
        self.album = json["items"][i]["track"]["album"]["name"].stringValue
        self.id = json["items"][i]["track"]["id"].stringValue
        self.url = json["items"][i]["track"]["href"].stringValue
        self.spotifyUri = json["items"][i]["track"]["uri"].stringValue
    }
}

