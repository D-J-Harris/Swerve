//
//  AppDelegate.swift
//  Swerve
//
//  Created by Daniel Harris on 23/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Firebase
        FirebaseApp.configure()
        //Spotify
        setupSpotify()
        
        configureInitialRootViewController(for: window)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        UserService.resetUserValues(User.current)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UserService.resetUserValues(User.current)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserService.resetUserValues(User.current)
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //Spotify auth
    func setupSpotify() {
        SPTAuth.defaultInstance().clientID = Constants.spotify.clientID
        SPTAuth.defaultInstance().redirectURL = Constants.spotify.redirectURI
        SPTAuth.defaultInstance().sessionUserDefaultsKey = Constants.spotify.sessionKey
        
        //scopes to use
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthUserLibraryReadScope]
        
        //for streaming purposes
        do {
            try SPTAudioStreamingController.sharedInstance().start(withClientId: Constants.spotify.clientID)
        } catch {
            fatalError("Couldn't start Spotify SDK")
        }
    }

    //This function is called when the app is opened by a URL
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //Check if this URL was sent from the Spotify app or website
        if SPTAuth.defaultInstance().canHandle(url) {
            
            //handle callback in closure
            SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) in
                
                if error != nil {
                    print("error!")
                }
            
            //add to user defaults
            let sessionData = NSKeyedArchiver.archivedData(withRootObject: session!)
            UserDefaults.standard.set(sessionData, forKey: "SpotifySession")
            UserDefaults.standard.synchronize()

            
            //Send out a notification which we can listen for in our sign in view controller
            NotificationCenter.default.post(name: NSNotification.Name.Spotify.loginSuccessful, object: nil)
            })
            return true
        }
        
        return false
    }



}

extension Notification.Name {
    struct Spotify {
        static let loginSuccessful = Notification.Name("loginSuccessful")
    }
}

extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if let _ = Auth.auth().currentUser,
            let userData = defaults.object(forKey: "currentUser") as? Data,
            let user = try? JSONDecoder().decode(User.self, from: userData) {
            User.setCurrent(user)
            initialViewController = UIStoryboard.initialViewController(for: .main)
        } else {
            initialViewController = UIStoryboard.initialViewController(for: .login)
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}

