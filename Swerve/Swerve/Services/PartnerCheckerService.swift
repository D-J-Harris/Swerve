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

struct PartnerCheckerService {
    
    
    
    
    //I should add code to return the user with the closest integral value (not just any old close value)
    //Also search only for devices on the opposite sender/receiver type (fine on small scale)
    func findMatchingDevice(_ currentUser: User, _ viewController: UIViewController) {
        
        let integralKeyTolerance = 0.5
        
        //overlay display start
        LoadingOverlay.shared.showOverlay(viewController.view)
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            
            //loop over all users to find matching integralKey
            let ref = Database.database().reference().child("users")
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
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
                let alertController = UIAlertController(title: "Match Info", message: "You matched with \(currentUser.matchedWith). Is this correct?", preferredStyle: .alert)
                
                let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    if currentUser.type == Constants.UserDictionary.receiver {
                        viewController.performSegue(withIdentifier: Constants.Segue.toDisplayResult, sender: viewController)
                    }
                })
                let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
                
                alertController.addAction(actionYes)
                alertController.addAction(actionNo)
                
                viewController.present(alertController, animated: true, completion: nil)
                
                
                
                //loading overlay hides
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
}
