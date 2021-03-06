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

//SONG FUNCTIONS START

//Each call can return a max of 50 tracks, offset used to get others in separate calls
func getTrackList(completion: @escaping ([Track]) -> Void) {
    var trackList: [Track] = []
    
    //Initialise callback helpers
    var callCount: Int = 50
    var offset: Int = 0

    //Spotify auth related info
    let auth = SPTAuth.defaultInstance()!
    guard let accessToken = auth.session.accessToken else {return completion([])}
    let headers = ["Authorization": "Bearer \(accessToken)"]
    
    //near-complete api url, appended with relevant offset for corresponding call
    let apiToCall = "https://api.spotify.com/v1/me/tracks?limit=50&offset="
    
    
    //HERE BEGINS CODE ASYNC TO UPDATE TRACKLIST W ALL SONGS
    var callback: ((DataResponse<Any>) -> (Void))!
    callback = { (response) in
        switch response.result {
        case .success:
            if let value = response.result.value {
                let jsonDict = value as! JSON
                let tracks = jsonDict["items"] as! [JSON]
                callCount = tracks.count
                    
                    
                //add each track to an array of tracks
                for t in tracks {
                    let track = Track.init(libraryJsonDict: t)
                    trackList.append(track)
                }
            }
            trackList = trackList.sorted{ $0.name < $1.name }
            if trackList.count % 50 != 0 || callCount == 0 {
                completion(trackList)
            } else {
                //offset the api call and go again
                offset += 50
                Alamofire.request(apiToCall + String(offset), headers: headers).validate().responseJSON(completionHandler: callback)
            }
                
        //Alamofire call failed, likely wrong token
        case .failure(let error):
            print(error)
            completion([])
        }
    }
    
    
    //Initial request that triggers all calls via callback above
    Alamofire.request(apiToCall + String(offset), headers: headers).validate().responseJSON(completionHandler: callback)
            //HERE ENDS CODE ASYNC TO UPDATE TRACKLIST W ALL SONGS
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

//PUT API call to add song to current user's spotify
func addSongToSpotify(songID id: String) {
    let apiToCall = "https://api.spotify.com/v1/me/tracks?ids=\(id)"
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

//SONG FUNCTIONS END

//PLAYLIST FUNCTIONS START

func getPlaylists(completion: @escaping ([Playlist]) -> Void) {
    var playlists: [Playlist] = []

    //Initialise callback helpers
    var callCount: Int = 50
    var offset: Int = 0

    //Spotify auth related info
    let auth = SPTAuth.defaultInstance()!
    guard let accessToken = auth.session.accessToken else {return completion([])}
    let headers = ["Authorization": "Bearer \(accessToken)"]

    //near-complete api url, appended with relevant offset for corresponding call
    let apiToCall = "https://api.spotify.com/v1/me/playlists?limit=50&offset="


    //HERE BEGINS CODE ASYNC TO UPDATE TRACKLIST W ALL SONGS
    var callback: ((DataResponse<Any>) -> (Void))!
    callback = { (response) in
        switch response.result {
        case .success:
            if let value = response.result.value {
                let jsonDict = value as! JSON
                let allPlaylists = jsonDict["items"] as! [JSON]
                callCount = allPlaylists.count


                //add each track to an array of tracks
                for p in allPlaylists {
                    let playlist = Playlist.init(libraryJsonDict: p)
                    playlists.append(playlist)
                }
            }
            if playlists.count % 50 != 0 || callCount == 0 {
                print(playlists)
                completion(playlists)
            } else {
                //offset the api call and go again
                offset += 50
                Alamofire.request(apiToCall + String(offset), headers: headers).validate().responseJSON(completionHandler: callback)
            }

        //Alamofire call failed, likely wrong token
        case .failure(let error):
            print(error)
            completion([])
        }
    }


    //Initial request that triggers all calls via callback above
    Alamofire.request(apiToCall + String(offset), headers: headers).validate().responseJSON(completionHandler: callback)
    //HERE ENDS CODE ASYNC TO UPDATE TRACKLIST W ALL SONGS
}


func getPlaylist(playlistID id: String, _ creatorID: String, completion: @escaping (Playlist) -> Void) {
    let apiToCall = "https://api.spotify.com/v1/users/\(creatorID)/playlists/\(id)"
    var playlist: Playlist = Playlist.init(name: "", creator: "", id: "", url: "", spotifyUri: "")
    
    let auth = SPTAuth.defaultInstance()!
    guard let accessToken = auth.session.accessToken else {return}
    let headers = ["Authorization": "Bearer \(accessToken)"]
    
    //call for song from users tracks list
    Alamofire.request(apiToCall, headers: headers).validate().responseJSON { (response) in
        switch response.result {
        case .success:
            if let value = response.result.value {
                let jsonDict = value as! JSON
                
                
                playlist = Playlist.init(jsonDict: jsonDict)
            }
            completion(playlist)
            
        //Alamofire call failed, likely wrong token
        case .failure(let error):
            print(error)
            completion(playlist)
        }
    }
}

func addPlaylistToSpotify(playlistID id: String, _ currentID: String) {
    
    //use the api call that allows to follow a playlist
    let apiToCall = "https://api.spotify.com/v1/users/\(currentID)/playlists/\(id)/followers"
    let auth = SPTAuth.defaultInstance()!
    
    guard let accessToken = auth.session.accessToken else {return}
    let headers = [
        "Authorization": "Bearer \(accessToken)",
        "Content-Type": "application/json"
    ]
    
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

//PLAYLIST FUNCTIONS END

func getCurrentSpotifyID(completion: @escaping (String?) -> Void) {
    let apiToCall = "https://api.spotify.com/v1/me"
    let auth = SPTAuth.defaultInstance()!
    var currentSpotifyID: String? = nil
    
    guard let accessToken = auth.session.accessToken else {return}
    let headers = ["Authorization": "Bearer \(accessToken)"]
    
    //Call to get user profile
    Alamofire.request(apiToCall, headers: headers).validate().responseJSON { (response) in
        switch response.result {
        case .success:
            if let value = response.result.value {
                let jsonDict = value as! JSON
                
                
                currentSpotifyID = jsonDict["id"] as? String
            }
            completion(currentSpotifyID)
            
        //Alamofire call failed, likely wrong token
        case .failure(let error):
            print(error)
            completion(currentSpotifyID)
        }
    }
}

