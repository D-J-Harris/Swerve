//
//  FirebaseCheckerService.swift
//  Swerve
//
//  Created by Daniel Harris on 28/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FirebaseCheckerService {
    
    static func findMatchingDevice(_ currentUser: User, _ viewController: UIViewController) {
        
        let integralKeyTolerance = 0.5
        
        //run loop through receivers to find matching key
        DispatchQueue.global(qos: .userInitiated).async {
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            sleep(3) //just to make sure keys updated, fix this solution
            //loop over receivers until match found for opposite type
            //find opposite type
            let searcherType = currentUser.type
            var ref = Database.database().reference()
            
            switch searcherType {
            case "sender":
                ref = ref.child(Constants.UserDictionary.receiver)
            case "receiver":
                ref = ref.child(Constants.UserDictionary.sender)
            default:
                print("User has unselected type")
            }
            
            
            ref.observe(.value) { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in snapshots {
                        guard let userDict = child.value as? [String: Any],
                            let integralKey = userDict["integralKey"] as? Double else { return }
                        print(integralKey)
                        print(currentUser.integralKey)
                        if abs(currentUser.integralKey - integralKey) < integralKeyTolerance {
                            print("Match found with \(userDict["username"] ?? "somebody")")
                            print("Word to be passed: \(userDict["passableTestText"] ?? "not applicable for sender")")
                            currentUser.matchedWith = userDict["username"] as! String
                            if currentUser.type == Constants.UserDictionary.receiver {
                                currentUser.passableTestText = userDict["passableTestText"] as! String
                            }
                        }
                    }
                }
                else {print("no snapshots exist")}
                dispatchGroup.leave()
            }
            
            
            let _ = dispatchGroup.wait(timeout: .now() + 3)
            DispatchQueue.main.async {
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
            }
        }
    }
}
