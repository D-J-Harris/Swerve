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
    var session = User.getSPTSession()
    
    //Initialised in either updateAfterFirstLogin or viewDidLoad (check for session in userDefaults)
    var player: SPTAudioStreamingController?
    var appURL: URL?
    var webURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpotify()
        
        // Before presenting the view controllers watch for the notification
        NotificationCenter.default.addObserver(self, selector: #selector(successfulLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func setupSpotify() {
        auth.clientID = Constants.spotify.clientID
        auth.redirectURL = Constants.spotify.redirectURI
        auth.sessionUserDefaultsKey = Constants.spotify.sessionKey
        auth.tokenSwapURL = Constants.spotify.tokenSwapURL
        auth.tokenRefreshURL = Constants.spotify.tokenRefreshURL
        webURL = auth.spotifyWebAuthenticationURL()
        appURL = auth.spotifyAppAuthenticationURL()
        
        //scopes to use
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthUserLibraryReadScope]
        
        
        
        //for streaming purposes
        do {
            try SPTAudioStreamingController.sharedInstance().start(withClientId: Constants.spotify.clientID)
        } catch {
            fatalError("Couldn't start Spotify SDK")
        }
    }
    
    
    
    @IBAction func spotifyLoginButtonPressed(_ sender: UIButton) {
        
        if auth.session == nil {

            //check if spotify installed
            if SPTAuth.supportsApplicationAuthentication() {
                //app login
                if let url = appURL {
                    UIApplication.shared.open(url, options: [:]) { (_) in
                        if !self.auth.canHandle(self.auth.redirectURL) {
                            print("error, redirect URL not handled")
                        }
                    }
                }
                else { print("app url doesn't exist") }  //could make these alerts later on
                
            }
            else {
                //web login
                if let url = webURL {
                    UIApplication.shared.open(url, options: [:]) { (_) in
                        if !self.auth.canHandle(self.auth.redirectURL) {
                            print("error, redirect URL not handled")
                        }
                    }
                }
                else { print("web url doesn't exist") }
                
            }
        }
        else {
            if !auth.session.isValid() {
                User.renewToken()
            }
            successfulLogin()
        }
    }
    
    @objc func successfulLogin() {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            // Present next view controller
            self.toMainStoryboard()
            
        }
    }
}


//extension for switching to the main storyboard
extension SpotifyLoginViewController {
    func toMainStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if let initialViewController = storyboard.instantiateInitialViewController() {
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}


