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
    let albumCoverURL: String
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
    
    init(json: JSON, _ i: Int){
        self.name = json["items"][i]["track"]["name"].stringValue
        self.artist = json["items"][i]["track"]["artists"][0]["name"].stringValue
        self.albumCoverURL = json["items"][i]["track"]["album"]["images"][0]["url"].stringValue
        self.id = json["items"][i]["track"]["id"].stringValue
        self.url = json["items"][i]["track"]["external_urls"]["spotify"].stringValue
        self.spotifyUri = json["items"][i]["track"]["uri"].stringValue
    }
}

