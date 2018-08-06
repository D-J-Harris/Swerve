//
//  SpotifyHelper.swift
//  Swerve
//
//  Created by Daniel Harris on 02/08/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String: Any]

//Can only get first 50 for now (API limit, can be fixed with offsets)
func getTrackList(completion: @escaping ([Track]) -> Void) {
        var trackList: [Track] = []
        let apiToCall = "https://api.spotify.com/v1/me/tracks?limit=50&offset=0"
    
    
        let auth = SPTAuth.defaultInstance()!
        guard let accessToken = auth.session.accessToken else {return}
        let headers = ["Authorization": "Bearer \(accessToken)"]
    
        //call for first 50 songs from users tracks list
        Alamofire.request(apiToCall, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonDict = value as! JSON


                    
                    //add each track to an array of tracks
                    for trackNumber in 0...49 {
                        let track = Track.init(jsonDict: jsonDict, trackNumber)
                        trackList.append(track)
                    }
                }
                trackList = trackList.sorted{ $0.name < $1.name }
                completion(trackList)
    
            //Alamofire call failed, likely wrong token
            case .failure(let error):
                print(error)
                completion([])
            }
        }
}

func getTrack(trackID id: String, completion: @escaping (Track) -> Void) {
    let apiToCall = "https://api.spotify.com/v1/tracks/\(id)"
    var track: Track = Track.init(name: "", artist: "", albumCoverURL: "", id: "", url: "", spotifyUri: "")

    let auth = SPTAuth.defaultInstance()!
    guard let accessToken = auth.session.accessToken else {return}
    let headers = ["Authorization": "Bearer \(accessToken)"]

    //call for song from users tracks list
    Alamofire.request(apiToCall, headers: headers).validate().responseJSON { (response) in
        switch response.result {
        case .success:
            if let value = response.result.value {
                let jsonDict = value as! JSON


                    track = Track.init(jsonDict: jsonDict)
            }
            completion(track)

        //Alamofire call failed, likely wrong token
        case .failure(let error):
            print(error)
            completion(track)
        }
    }
}

func addToSpotify(songID id: String) {
    let apiToCall = "https://api.spotify.com/v1/me/tracks"
    let auth = SPTAuth.defaultInstance()!
    
    guard let accessToken = auth.session.accessToken else {return}
    let headers = ["Authorization": "Bearer \(accessToken)"]
    
    //PUT request to add to current session user tracks
    Alamofire.request(apiToCall, method: .put, parameters: [:],encoding: JSONEncoding.default, headers: headers).responseJSON {
        response in
        switch response.result {
        case .success:
            print(response)
            
            break
        case .failure(let error):
            
            print(error)
        }
    }
}

