//
//  SenderInputViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit


class SenderInputViewController: UIViewController {
    
    //@IBOutlet weak var toMotionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    //retrieve SPT default instance
    let auth = SPTAuth.defaultInstance()!
    var trackList = [Track]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //having loading progress wait for the getTrackList to complete
        
        LoadingOverlay.shared.showOverlay(self.view)
        getTrackList(completion: { (tracks) -> Void in
            if !tracks.isEmpty {
                print("tracks downloaded")
                LoadingOverlay.shared.hideOverlayView()
            }
            else {
                print("no tracks exist")
            }
        })
        
        
        
        
        
        tableView.dataSource = self
        
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
            //destination.testLabelText = testTextTransferTextField.text ?? "No text entered"
            UserService.updateUserText(User.current, passableTestText: "")
        case Constants.Segue.backFromSender:
            User.current.type = Constants.UserDictionary.unselected
            UserService.updateUserType(User.current, type: Constants.UserDictionary.unselected)
        default:
            print("error no correct segue identified")
        }
    }

    
    //@IBAction func toMotionButtonTapped(_ sender: UIButton) {
    //    self.performSegue(withIdentifier: Constants.Segue.senderInfoToMotion, sender: self)
    //}
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue){
    }
}

//UITableViewDataSource
extension SenderInputViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TrackCell.height
    }
}

