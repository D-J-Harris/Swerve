//
//  SpotifyHelper.swift
//  Swerve
//
//  Created by Daniel Harris on 02/08/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//Can only get first 50 for now (API limit, can be fixed with offsets)
func getTrackList(completion: @escaping ([Track]) -> Void) {
        var trackList: [Track] = []
        let apiToCall = "https://api.spotify.com/v1/me/tracks?limit=10&offset=0"
        //^^^^first 10 for now to make testing faster^^^^
    
    
        let auth = SPTAuth.defaultInstance()!
        guard let accessToken = auth.session.accessToken else {return}
        let headers = ["Authorization": "Bearer \(accessToken)"]
    
        //call for first 50 songs from users tracks list
        Alamofire.request(apiToCall, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let sampleSize = json["items"].count
                   
                    
                    /*
                    //if sample size is 50, then update parameters ready for next call
                    if sampleSize == 50 {
                        offset += 50
                    } else {
                        tracksAreExhausted = true
                    }
                    */
                    
                    //add each track to an array of tracks
                    for trackNumber in 0...sampleSize - 1 {
                        let track = Track.init(json: json, trackNumber)
                        trackList.append(track)
                        print("name: \(track.name) albumCoverURL: \(track.albumCoverURL) artist: \(track.artist) id: \(track.id) spotifyURI: \(track.spotifyUri) URL: \(track.url)")
                    }
                }
                completion(trackList)
    
            //Alamofire call failed, likely wrong token
            case .failure(let error):
                print(error)
                completion([])
            }
        }
}

