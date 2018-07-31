//
//  SpotifyLoginViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 30/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class SpotifyLoginViewController: UIViewController {
    
    @IBOutlet weak var spotifyLoginButton: UIButton!
    
    //Spotify initialisations
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    //Initialised in either updateAfterFirstLogin or viewDidLoad (check for session in userDefaults)
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Before presenting the view controllers watch for the notification
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func spotifyLoginButtonPressed(_ sender: UIButton) {
        let appURL = auth.spotifyAppAuthenticationURL()!
        let webURL = auth.spotifyWebAuthenticationURL()!
        
        //check if spotify installed
        if SPTAuth.supportsApplicationAuthentication() {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        }
        else {
            //web login
            present(SFSafariViewController(url: webURL), animated: true, completion: nil)
        }
    }
    
    @objc func receievedUrlFromSpotify(_ notification: Notification) {
        guard let url = notification.object as? URL else { return }
        
        //spotifyAuthWebView?.dismiss(animated: true, completion: nil)
        
        auth.handleAuthCallback(withTriggeredAuthURL: url) { (error, session) in
            //Check if there is an error because then there won't be a session.
            if let error = error {
                self.displayErrorMessage(error: error)
                return
            }
            
            // Check if there is a session
            if let session = session {
                // The streaming login is asyncronious and will alert us if the user
                // was logged in through a delegate, so we need to implement those methods
                SPTAudioStreamingController.sharedInstance().delegate = self as! SPTAudioStreamingDelegate
                SPTAudioStreamingController.sharedInstance().login(withAccessToken: session.accessToken)
            }
        }
    }
    
    func displayErrorMessage(error: Error) {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func successfulLogin() {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            // Present next view controller or use performSegue(withIdentifier:, sender:)
            let storyboard = UIStoryboard(name: "SpotifyLogin", bundle: .main)
            
            if let initialViewController = storyboard.instantiateInitialViewController() {
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    @objc func updateAfterFirstLogin () {
        
        if let sessionObj:AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
    
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self as! SPTAudioStreamingPlaybackDelegate
            self.player!.delegate = self as! SPTAudioStreamingDelegate
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        self.successfulLogin()
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
}


