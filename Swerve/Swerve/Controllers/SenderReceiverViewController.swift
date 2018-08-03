//
//  SenderReceiverViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class SenderReceiverViewController: UIViewController {
    
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var receiverButton: UIButton!
    @IBOutlet weak var signoutButton: UIBarButtonItem!
    
    let auth = SPTAuth.defaultInstance()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case Constants.Segue.senderToSenderInfo:
            User.current.type = Constants.UserDictionary.sender
            UserService.updateUserType(User.current, type: Constants.UserDictionary.sender)
        case Constants.Segue.receiverToMotion:
            User.current.type = Constants.UserDictionary.receiver
            UserService.updateUserType(User.current, type: Constants.UserDictionary.receiver)
        default:
            print("error no correct segue identified")
        }
    }
    
    func handleSignOutButtonTapped() {
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            
            let auth = SPTAuth.defaultInstance()!
            
            //sign out of spotify session if one exists
            if auth.session != nil {
                auth.session = nil
            }
            do {
                //sign out of Firebase if user signed in
                try Auth.auth().signOut()
                let loginStoryboard = UIStoryboard(name: "Login", bundle: Bundle.main)
                let loginVC : UIViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginVC, animated: true, completion: nil)
            } catch let err {
                print("Failed to sign out with error", err)
                UserService.showAlert(on: self, style: .alert, title: "Sign Out Error", message: err.localizedDescription)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        UserService.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
    }
    
    
    @IBAction func signoutButtonTapped(_ sender: Any) {
        handleSignOutButtonTapped()
    }
    
    @IBAction func senderButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segue.senderToSenderInfo, sender: self)
    }
    
    @IBAction func receiverButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segue.receiverToMotion, sender: self)
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
}
