//
//  UserService.swift
//  Swerve
//
//  Created by Daniel Harris on 25/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username,
                         "type": Constants.UserDictionary.unselected,
                         "integralKey": "-1"]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func copyUserToSenders(_ currentUser: User) {
        let ref = Database.database().reference().child("senders").child(currentUser.uid)
        let userAttrs = ["username": currentUser.username,
                         "type": Constants.UserDictionary.sender,
                         "integralKey": currentUser.integralKey]
        
        ref.setValue(userAttrs)
    }
    
    static func copyUserToReceivers(_ currentUser: User) {
        let ref = Database.database().reference().child("receivers").child(currentUser.uid)
        let userAttrs = ["username": currentUser.username,
                         "type": Constants.UserDictionary.receiver,
                         "integralKey": currentUser.integralKey]
        
        ref.setValue(userAttrs)
    }
}
