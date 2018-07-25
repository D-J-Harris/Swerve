//
//  LoginViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 24/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = loginButton.frame.width / 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
       guard let authUI = FUIAuth.defaultAuthUI()
        else{
            return
        }
        
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            assertionFailure(error.localizedDescription)
            return
        }
        guard let user = authDataResult?.user
            else {
                return
        }
        let userRef = Database.database().reference().child("users/\(user.uid)")
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let user = User(snapshot: snapshot) {
                print("Welcome back, \(user.username)")
            } else {
                print("New user!")
            }
        }
    }
}

