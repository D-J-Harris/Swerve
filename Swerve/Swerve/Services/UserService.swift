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
                         "integralKey": -1.0,
                         "passableTestText": "",
                         "matchedWith": ""] as [String: Any]
        
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
        let ref = Database.database().reference().child(Constants.UserDictionary.sender).child(currentUser.uid)
        let userAttrs = ["username": currentUser.username,
                         "type": Constants.UserDictionary.sender,
                         "integralKey": currentUser.integralKey,
                         "passableTestText": currentUser.passableTestText,
                         "matchedWith": currentUser.matchedWith] as [String: Any]
        currentUser.type = Constants.UserDictionary.sender
        
        ref.setValue(userAttrs)
    }
    
    static func updateUserText(_ user: User, childNode node: String, passableTestText: String) {
        let ref = Database.database().reference().child(node).child(user.uid)
        let userAttrs = ["passableTestText": passableTestText]
        ref.updateChildValues(userAttrs)
    }
    
    static func updateMatchedWith(_ user: User, childNode node: String, matchedWith: String) {
        let ref = Database.database().reference().child(node).child(user.uid)
        let userAttrs = ["matchedWith": matchedWith]
        ref.updateChildValues(userAttrs)
    }
    
    static func updateUserIntegralKey(_ user: User, childNode node: String, integralKey: Double) {
        let ref = Database.database().reference().child(node).child(user.uid)
        let userAttrs = ["integralKey": integralKey]
        ref.updateChildValues(userAttrs)
    }
    
    static func copyUserToReceivers(_ currentUser: User) {
        let ref = Database.database().reference().child(Constants.UserDictionary.receiver).child(currentUser.uid)
        let userAttrs = ["username": currentUser.username,
                         "type": Constants.UserDictionary.receiver,
                         "integralKey": currentUser.integralKey,
                         "passableTestText": currentUser.passableTestText,
                         "matchedWith": currentUser.matchedWith] as [String: Any]
        currentUser.type = Constants.UserDictionary.receiver
        
        ref.setValue(userAttrs)
    }
    
    static func deleteUserReference(_ currentUser: User) {
        let userType = currentUser.type
        var ref = Database.database().reference()
        print("userType: \(userType)")
        switch userType {
        case Constants.UserDictionary.sender:
            ref = ref.child(Constants.UserDictionary.sender).child(currentUser.uid)
        case Constants.UserDictionary.receiver:
            ref = ref.child(Constants.UserDictionary.receiver).child(currentUser.uid)
        default:
            assertionFailure("User cannot be removed, is not sender or receiver")
        }

        ref.removeValue { (error, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
         User.current.type = Constants.UserDictionary.unselected
    }
}
