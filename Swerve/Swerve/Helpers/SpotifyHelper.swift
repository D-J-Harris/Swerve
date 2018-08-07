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

//Each call can return a max of 50 tracks, offset used to get others in separate calls
func getTrackList(completion: @escaping ([Track]) -> Void) {
        var trackList: [Track] = []
    
        //boolean value to check if call should be made again
        var isExhausted = false
        var callCount: Int = 50
        var offset: Int = 0

        //Spotify auth related info
        let auth = SPTAuth.defaultInstance()!
        guard let accessToken = auth.session.accessToken else {return}
        let headers = ["Authorization": "Bearer \(accessToken)"]
    
        let apiToCall = "https://api.spotify.com/v1/me/tracks?limit=50&offset=\(offset)"
    
    
        //create dispatchQueue so we can wait to see if another call should be made
//        let dispatchQueue = DispatchGroup()
    
//        while isExhausted != true {
//            dispatchQueue.enter()
    
    
            //HERE BEGINS CODE ASYNC TO UPDATE TRACKLIST W 50 SONGS
            Alamofire.request(apiToCall, headers: headers).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let jsonDict = value as! JSON
                        print("-------\(jsonDict)")
                        callCount = (jsonDict["items"] as! [JSON]).count

                        
                        //add each track to an array of tracks
                        for trackNumber in 0...callCount - 1 {
                            let track = Track.init(jsonDict: jsonDict, trackNumber)
                            trackList.append(track)
                        }
                    }
                    trackList = trackList.sorted{ $0.name < $1.name }
//                    dispatchQueue.leave()
                    completion(trackList)
        
                //Alamofire call failed, likely wrong token
                case .failure(let error):
                    print(error)
//                    dispatchQueue.leave()
                    completion([])
                }
                
            }
            //HERE ENDS CODE ASYNC TO UPDATE TRACKLIST W 50 SONGS
        
//            dispatchQueue.wait()
//                if callCount != 50 {
//                    print(callCount)
//                    print("----\(isExhausted)")
//                    isExhausted = true
//                }
//                else {
//                    offset += 50
//                    print("------------")
//                }
    
//    }

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

