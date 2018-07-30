//
//  FirebaseCheckerService.swift
//  Swerve
//
//  Created by Daniel Harris on 28/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

struct FirebaseCheckerService {
    
    static func findMatchingDevice(_ currentUser: User, _ viewController: UIViewController) {
        
        let integralKeyTolerance = 0.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
        
            //loop over all users to find matching integralKey
            let ref = Database.database().reference().child("users")

            ref.observe(.value) { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in snapshots {
                        guard let userDict = child.value as? [String: Any],
                            let integralKey = userDict["integralKey"] as? Double else { return }
                        
                        //loop over all users but current
                        if(child.key != currentUser.uid) {
                            if abs(currentUser.integralKey - integralKey) < integralKeyTolerance {
                                print("Match found with \(userDict["username"] ?? "somebody")")
                                print("Word to be passed: \(userDict["passableTestText"] ?? "not applicable for sender")")
                                currentUser.matchedWith = userDict["username"] as! String
                                UserService.updateMatchedWith(currentUser, matchedWith: userDict["username"] as! String)
                                if currentUser.type == Constants.UserDictionary.receiver {
                                    currentUser.passableTestText = userDict["passableTestText"] as! String
                                    UserService.updatePassableTestText(currentUser, passableTestText: userDict["passableTestText"] as! String)
                                }
                            }
                        }
                    }
                }
                else {print("no snapshots exist")}
                
                //Match Info Alert
                let alertControllerSender = UIAlertController(title: "Match Info", message: "You matched with \(currentUser.matchedWith)", preferredStyle: .alert)
                let alertControllerReceiver = UIAlertController(title: "Match Info", message: "You matched with \(currentUser.matchedWith), and received \(currentUser.passableTestText)", preferredStyle: .alert)
                
                let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertControllerSender.addAction(actionOk); alertControllerReceiver.addAction(actionOk)
                
                if currentUser.type == Constants.UserDictionary.sender {
                    viewController.present(alertControllerSender, animated: true, completion: nil)
                }
                else if currentUser.type == Constants.UserDictionary.receiver {
                    viewController.present(alertControllerReceiver, animated: true, completion: nil)
                }
                
                //loading overlay hides
                LoadingOverlay.shared.hideOverlayView()
            
            }
            //I should add code to return the user with the closest integral value (not just any old close value)
            //Also search only for devices on the opposite sender/receiver type (fine on small scale)
    
        }
        //overlay display start
        LoadingOverlay.shared.showOverlay(viewController.view)
    }
}
