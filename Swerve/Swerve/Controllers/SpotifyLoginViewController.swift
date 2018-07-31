//
//  SpotifyLoginViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 30/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit

class SpotifyLoginViewController: UIViewController {
    
    @IBOutlet weak var spotifyLoginButton: UIButton!
    
    //Spotify initialisations
    var auth: SPTAuth = SPTAuth.defaultInstance()
    var session: SPTSession!
    
    //Initialised in either updateAfterFirstLogin or viewDidLoad (check for session in userDefaults)
    var player: SPTAudioStreamingController?
    var appURL: URL?
    var webURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpotify()
        // Before presenting the view controllers watch for the notification
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func setupSpotify() {
        auth.clientID = Constants.spotify.clientID
        auth.redirectURL = Constants.spotify.redirectURI
        auth.sessionUserDefaultsKey = Constants.spotify.sessionKey
        webURL = auth.spotifyWebAuthenticationURL()
        appURL = auth.spotifyAppAuthenticationURL()
        
        //scopes to use
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthUserLibraryReadScope]
        
        
        
        //for streaming purposes
        do {
            try SPTAudioStreamingController.sharedInstance().start(withClientId: Constants.spotify.clientID)
            print("audio player found")
        } catch {
            fatalError("Couldn't start Spotify SDK")
        }
    }
    
    
    
    @IBAction func spotifyLoginButtonPressed(_ sender: UIButton) {
        
        
        //check if first time login
//        if auth.session != nil {
//            if auth.session.isValid() {
//                self.toMainStoryboard()
//                return
//            }
//            //refresh token
//            renewTokenAndShowSearchVC()
//            return
//        }

        //check if spotify installed
        if SPTAuth.supportsApplicationAuthentication() {
            if let url = appURL {
                print("app url found")
                UIApplication.shared.open(url, options: [:]) { (_) in
                    if self.auth.canHandle(self.auth.redirectURL) {
                        //build in error handling
                        print("handled")
                    }
                }
            }
            else { print("app url doesn't exist") }
            
        }
        else {
            //web login
            if let url = webURL {
                print("web url found")
                UIApplication.shared.open(url, options: [:]) { (_) in
                    if self.auth.canHandle(self.auth.redirectURL) {
                        //build in error handling
                    }
                }
            }
            else { print("web url doesn't exist") }
            
        }
    }
    
    func renewTokenAndShowSearchVC() {
        
        print("Refreshing token...")
        
        let auth:SPTAuth = SPTAuth.defaultInstance()
        auth.renewSession(auth.session) { (error, session) in
            auth.session = session
            
            if let error = error {
                print("Refreshing token failed.")
                print(error.localizedDescription)
                return
            }
            self.toMainStoryboard()
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
            print("successful login performed using successfulLogin()")
            self.toMainStoryboard()
            
        }
    }
    
    @objc func updateAfterFirstLogin() {
        print("first login function reached")
        successfulLogin()
        
    }
    
    /*
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    */
}

extension SpotifyLoginViewController {
    func toMainStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if let initialViewController = storyboard.instantiateInitialViewController() {
            print("Main called here")
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}


