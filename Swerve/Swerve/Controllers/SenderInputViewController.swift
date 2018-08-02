//
//  SenderInputViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage


class SenderInputViewController: UIViewController {
    
    //@IBOutlet weak var toMotionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    //retrieve SPT default instance
    let auth = SPTAuth.defaultInstance()!
    var trackList = [Track]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Handle tapping to deactivate keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //having loading progress wait for the getTrackList to complete
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        LoadingOverlay.shared.showOverlay(self.view)
        getTrackList { (tracks) in
            if !tracks.isEmpty {
                print("tracks downloaded")
                self.trackList = tracks
            }
            else {
                print("no tracks exist")
            }
            dispatchGroup.leave()
        }
        
        
        //Once download complete, update table view
        dispatchGroup.notify(queue: DispatchQueue.main) {
            LoadingOverlay.shared.hideOverlayView()
            print(self.trackList.count)
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
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
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let track = trackList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        
        cell.trackName.text = track.name
        cell.artistName.text = track.artist
        cell.trackID = track.id
        if let trackCoverURL = track.albumCoverURL {
            cell.albumCover.af_setImage(withURL: URL(string: trackCoverURL)!)
        }
        
        return cell
    }
}

