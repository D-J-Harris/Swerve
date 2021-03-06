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
import AVKit
import AVFoundation

class SenderReceiverViewController: UIViewController {
    
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var receiverButton: UIButton!
    @IBOutlet weak var signoutButton: UIBarButtonItem!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var welcomeBackLabel: UILabel!
    @IBOutlet weak var instructionsButton: UIButton!
    
    
    let auth = SPTAuth.defaultInstance()!
    //Initialise player controller for instructions
    let playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()
        
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor(displayP3Red: 0.431, green: 0.918, blue: 0.667, alpha: 1).cgColor,
                           UIColor(displayP3Red: 0.961, green: 0.408, blue: 0.349, alpha: 1).cgColor,
                           UIColor(displayP3Red: 0.878, green: 0.898, blue: 0.243, alpha: 1).cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        receiverButton.layer.cornerRadius = 5
        senderButton.layer.cornerRadius = 5
        welcomeBackLabel.text = "Welcome back, \(User.current.username)"
        welcomeBackLabel.adjustsFontSizeToFitWidth = true
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
                UserService.resetUserValues(User.current)
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
    
    //TUTORIAL VIDEO START
    
    @IBAction func instructionsButtonTapped(_ sender: UIButton) {
        playVideo()
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "SwerveTutorial", ofType:"mp4") else {
            debugPrint("SwerveTutorial.mp4 not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        playerController.player = player
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerController.player?.currentItem)
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        playerController.dismiss(animated: true, completion: nil)
    }
    
    //TUTORIAL VIDEO END
    
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
}
