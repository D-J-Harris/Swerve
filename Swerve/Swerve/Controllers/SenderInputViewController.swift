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
    var songID: String? = nil
    var arrIndexSection : NSArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //having loading progress wait for the getTrackList to complete
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        LoadingOverlay.shared.showOverlay(self.view)
        getTrackList { (tracks) in
            if !tracks.isEmpty {
                print("tracks downloaded")
                self.trackList = tracks
                LoadingOverlay.shared.hideOverlayView()
            }
            else {
                print("no tracks exist")
            }
            dispatchGroup.leave()
        }
        
        
        //Once download complete, update table view
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case Constants.Segue.senderInfoToMotion:
            let destination = segue.destination as! MotionViewController
            destination.testLabelText = songID ?? "No Song ID"
            UserService.updateUserText(User.current, passableTestText: songID ?? "No Song ID")
        case Constants.Segue.backFromSender:
            User.current.type = Constants.UserDictionary.unselected
            UserService.updateUserType(User.current, type: Constants.UserDictionary.unselected)
        default:
            print("error no correct segue identified")
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue){
    }
}



//UITableViewDataSource
extension SenderInputViewController: UITableViewDataSource {
    
    //26 sections for each letter of alphabet
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrIndexSection.count
    }
    
    //Jump nav bar
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return arrIndexSection as? [String]
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrIndexSection.object(at: section) as? String
    }
    
    
    
    //rows for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let predicate = NSPredicate(format: "SELF beginswith[c] %@", arrIndexSection.object(at: section) as! CVarArg)
        let filteredTracks = (trackList.map {$0.name} as NSArray).filtered(using: predicate)
        return filteredTracks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        let predicate = NSPredicate(format: "SELF beginswith[c] %@", arrIndexSection.object(at: indexPath.section) as! CVarArg)
        let filteredTracks = trackList.filter({return predicate.evaluate(with: $0.name)})
        cell.trackName.text = filteredTracks[indexPath.row].name
        cell.artistName.text = filteredTracks[indexPath.row].artist
        cell.trackID = filteredTracks[indexPath.row].id
        if let trackCoverURL = filteredTracks[indexPath.row].albumCoverURL {
            cell.albumCover.af_setImage(withURL: URL(string: trackCoverURL)!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TrackCell.height
    }
    
}

extension SenderInputViewController: UITableViewDelegate {
    
    //selecting row sets up transition to motionVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! TrackCell
        
        songID = currentCell.trackID
        
        //set up and present alert to segue to motionVC
        let alertController = UIAlertController(title: "Send Song", message: "Are you sure you would like to send \(trackList[indexPath.row].name)" , preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: Constants.Segue.senderInfoToMotion, sender: self)
            
        })
        let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(actionYes)
        alertController.addAction(actionNo)
        
        present(alertController, animated: true, completion: nil)
        
    }
}
