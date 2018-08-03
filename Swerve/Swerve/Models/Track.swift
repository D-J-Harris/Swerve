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
    
    init(json: JSON, _ i: Int){
        self.name = json["items"][i]["track"]["name"].stringValue
        self.artist = json["items"][i]["track"]["artists"][0]["name"].stringValue
        self.albumCoverURL = json["items"][i]["track"]["album"]["images"][0]["url"].stringValue
        self.id = json["items"][i]["track"]["id"].stringValue
        self.url = json["items"][i]["track"]["external_urls"]["spotify"].stringValue
        self.spotifyUri = json["items"][i]["track"]["uri"].stringValue
    }
    
    init(json: JSON){
        self.name = json["name"].stringValue
        self.artist = json["artists"][0]["name"].stringValue
        self.albumCoverURL = json["album"]["images"][0]["url"].stringValue
        self.id = json["id"].stringValue
        self.url = json["external_urls"]["spotify"].stringValue
        self.spotifyUri = json["uri"].stringValue
    }
    
//    init(orgJson: AnyObject, _ i: Int){
//        guard let array = orgJson as? NSArray else {return}
//
//        self.name = array[1][i][1][10] as String
//        self.artist = array["items"][i]["track"]["artists"][0]["name"] as String
//        self.albumCoverURL = array["items"][i]["track"]["album"]["images"][0]["url"] as String
//        self.id = array["items"][i]["track"]["id"] as String
//        self.url = array["items"][i]["track"]["external_urls"]["spotify"] as String
//        self.spotifyUri = array["items"][i]["track"]["uri"] as String
//    }
}

