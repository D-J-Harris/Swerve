//
//  User.swift
//  Swerve
//
//  Created by Daniel Harris on 24/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: Codable {
    
    let uid: String
    let username: String
    var type: String
    var integralKey: Double
    var passableTestText: String
    var matchedWith: String
    
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        self.type = Constants.UserDictionary.unselected
        self.integralKey = -1.0
        self.passableTestText = ""
        self.matchedWith = ""
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String,
            let type = dict["type"] as? String,
            let integralKey = dict["integralKey"] as? Double,
            let passableTestText = dict["passableTestText"] as? String,
            let matchedWith = dict["matchedWith"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        self.type = type
        self.integralKey = integralKey
        self.passableTestText = passableTestText
        self.matchedWith = matchedWith
    }
    
    private static var _current: User?

    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: "currentUser")
            }
            
        }
        
        _current = user
    }
    
    static func isUserAlreadyLoggedIn() -> Bool {
        let userDefaults = UserDefaults.standard
        guard let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject?,
            let sessionDataObj = sessionObj as? Data,
            let _ = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession else {
                return false
        }
        return true
    }
    
    /*
    func search(query: String, callback: @escaping ([Track]) -> Void) -> Void {
        
        let auth: SPTAuth = SPTAuth.defaultInstance()
        let token = auth.session.accessToken
        
        SPTSearch.perform(withQuery: query, queryType: .queryTypeTrack, accessToken: token, market: "Country_Code") { (error, result) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let listPage = result as? SPTListPage,
                let items = listPage.items as? [SPTPartialTrack],
                let artist = items.first?.artists.first as? SPTPartialArtist {
                
                let tracks = items.compactMap({ (pTrack) -> Track in
                    
                    let name: String = pTrack.name
                    let artist: String = artist.name
                    let album: String = pTrack.album.name
                    
                    return Track(name: name , artist: artist, album: album)
                })
                
                callback(tracks)
            }
        }
    }
    */
}
