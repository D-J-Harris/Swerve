//
//  SenderInputViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class SenderInputViewController: UIViewController {
    
    @IBOutlet weak var toMotionButton: UIButton!
    @IBOutlet weak var testTextTransferTextField: UITextField!
    
    //retrieve SPT default instance
    let auth = SPTAuth.defaultInstance()!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTrackList { (tracks) in
            //
        }
        
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case Constants.Segue.senderInfoToMotion:
            let destination = segue.destination as! MotionViewController
            destination.testLabelText = testTextTransferTextField.text ?? "No text entered"
            UserService.updateUserText(User.current, passableTestText: testTextTransferTextField.text ?? "No text entered")
        case Constants.Segue.backFromSender:
            User.current.type = Constants.UserDictionary.unselected
            UserService.updateUserType(User.current, type: Constants.UserDictionary.unselected)
        default:
            print("error no correct segue identified")
        }
    }
    
    
    func getTrackList(completion: @escaping ([Track]) -> Void) {
        var trackList: [Track] = []
        let apiToCall = "https://api.spotify.com/v1/me/tracks"
        
        let auth = SPTAuth.defaultInstance()!
        guard let accessToken = auth.session.accessToken else {return}

        let headers = ["Authorization": "Bearer \(accessToken)"]
        Alamofire.request(apiToCall, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    //for track in 0...49 {
                        let track = Track.init(json: json, 0)
                        trackList.append(track)
                        print("name: \(track.name) album: \(track.album) artist: \(track.artist) id: \(track.id) spotifyURI: \(track.spotifyUri) URL: \(track.url)")
                   // }
                }
            case .failure(let error):
                print(error)
            }
            completion(trackList)
        }
    }
    
    
    
    
    
    
    
    
    @IBAction func toMotionButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segue.senderInfoToMotion, sender: self)
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue){
    }
}
