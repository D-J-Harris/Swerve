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
    let type: String
    let integralKey: String
    
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        self.type = Constants.UserDictionary.unselected
        self.integralKey = "-1"
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String,
            let type = dict["type"] as? String,
            let integralKey = dict["integralKey"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        self.type = type
        self.integralKey = integralKey
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
}
