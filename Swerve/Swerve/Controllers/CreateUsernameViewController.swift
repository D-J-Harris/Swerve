//
//  CreateUsername.swift
//  Swerve
//
//  Created by Daniel Harris on 25/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var createUsernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.width / 2
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor(displayP3Red: 0.431, green: 0.918, blue: 0.667, alpha: 1).cgColor
        createUsernameLabel.adjustsFontSizeToFitWidth = true
        createUsernameLabel.layer.borderWidth = 1
        createUsernameLabel.layer.borderColor = UIColor(displayP3Red: 0.431, green: 0.918, blue: 0.667, alpha: 1).cgColor
        
        //Handle tapping to deactivate keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Calls this function when the tap is recognized
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else { return }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            let storyboard = UIStoryboard(name: "Spotifylogin", bundle: .main)
            
            if let initialViewController = storyboard.instantiateInitialViewController() {
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
