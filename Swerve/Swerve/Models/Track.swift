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
    
    init(name: String, artist: String, album: String) {
        self.name = name
        self.artist = artist
        self.album = album
    }
    
    init(json: JSON){
        self.name = json
        self.timezone = json["Results"][0]["tzs"].stringValue
        self.latitude = json["Results"][0]["lat"].stringValue
        self.longitude = json["Results"][0]["lon"].stringValue
    }
}

