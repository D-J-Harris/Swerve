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
    //create new user in Firebase database
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username,
                         "type": Constants.UserDictionary.unselected,
                         "integralKey": -1.0,
                         "sendID": "",
                         "matchedSpotifyID": "",
                         "matchedWith": "nobody"] as [String: Any]
        
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
    
    static func updateMatchedWith(_ user: User, matchedWith: String) {
        let ref = Database.database().reference().child("users").child(user.uid)
        let userAttrs = ["matchedWith": matchedWith]
        ref.updateChildValues(userAttrs)
        user.matchedWith = matchedWith
    }
    
    static func updateUserIntegralKey(_ user: User, integralKey: Double) {
        let ref = Database.database().reference().child("users").child(user.uid)
        let userAttrs = ["integralKey": integralKey]
        ref.updateChildValues(userAttrs)
        user.integralKey = integralKey
    }
    
    static func updateUserType(_ user: User, type: String) {
        let ref = Database.database().reference().child("users").child(user.uid)
        let userAttrs = ["type": type]
        ref.updateChildValues(userAttrs)
        user.type = type
    }
    
    static func updateSendID(_ user: User, sendID: String) {
        let ref = Database.database().reference().child("users").child(user.uid)
        let userAttrs = ["sendID": sendID]
        ref.updateChildValues(userAttrs)
        user.sendID = sendID
    }
    
    static func updateMatchedSpotifyID(_ user: User, matchedSpotifyID: String) {
        let ref = Database.database().reference().child("users").child(user.uid)
        let userAttrs = ["matchedSpotifyID": matchedSpotifyID]
        ref.updateChildValues(userAttrs)
        user.matchedSpotifyID = matchedSpotifyID
    }
    
    static func resetUserValues(_ user: User) {
        let ref = Database.database().reference().child("users").child(user.uid)
        let userAttrs = ["type": Constants.UserDictionary.unselected,
                         "integralKey": -1.0,
                         "sendID": "",
                         "matchedSpotifyID": "",
                         "matchedWith": "nobody"] as [String: Any]
        ref.updateChildValues(userAttrs)
        user.integralKey = -1.0; user.matchedWith = "nobody"; user.sendID = ""; user.matchedSpotifyID = ""; user.type = Constants.UserDictionary.unselected
    }
    
    //function to display alerts
    static func showAlert(on: UIViewController, style: UIAlertControllerStyle, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: completion)
    }
}

    /*
    Keep in case want to add a delete account option


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
 
    */
