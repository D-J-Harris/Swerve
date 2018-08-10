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
    @IBOutlet weak var sendTypeSelector: UISegmentedControl!
    
    
    //retrieve SPT default instance
    let auth = SPTAuth.defaultInstance()!
    var trackList = [Track]()
    var playlists = [Playlist]()
    var songID: String? = nil
    var playlistID: String? = nil
    var creatorID: String? = nil
    var currentTableView: Int = 0
    var arrIndexSection : NSArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionIndexColor = UIColor(displayP3Red: 0.482, green: 0.502, blue: 0.478, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //having loading progress wait for the getTrackList to complete
        let dispatchGroup = DispatchGroup()
        //enter twice, this must be balanced by two complete API requests
        dispatchGroup.enter()
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
        
        getPlaylists { (playlists) in
            if !playlists.isEmpty {
                print("playlists downloaded")
                self.playlists = playlists
            }
            else {
                print("no playlists exist")
            }
            dispatchGroup.leave()
        }
        
        
        //Once download complete, update table view
        dispatchGroup.notify(queue: DispatchQueue.main) {
            LoadingOverlay.shared.hideOverlayView()
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func switchTableViewAction(_ sender: UISegmentedControl) {
        currentTableView = currentTableView == 1 ? 0 : 1
        tableView.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case Constants.Segue.senderInfoToMotion:
            UserService.updateSendID(User.current, sendID: songID ?? playlistID ?? "No ID")
            UserService.updateMatchedSpotifyID(User.current, matchedSpotifyID: creatorID ?? "No creator ID")
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
        switch currentTableView {
        case 0:
            return arrIndexSection.count
        case 1:
            return 1
        default:
            return 1
        }
        
    }
    
    //Jump nav bar
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        switch currentTableView {
        case 0:
            return arrIndexSection as? [String]
        case 1:
            return [""]
        default:
            return [""]
        }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch currentTableView {
        case 0:
            return arrIndexSection.object(at: section) as? String
        case 1:
            return "My Playlists"
        default:
            return "No title header found"
        }
    }
    
    
    
    //rows for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentTableView {
        case 0:
            let predicate = NSPredicate(format: "SELF beginswith[c] %@", arrIndexSection.object(at: section) as! CVarArg)
            let filteredTracks = (trackList.map {$0.name} as NSArray).filtered(using: predicate)
            return filteredTracks.count;
        case 1:
            return playlists.count
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentTableView {
        case 0:
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
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as! PlaylistCell
            cell.creatorName.text = playlists[indexPath.row].creator
            cell.playlistName.text = playlists[indexPath.row].name
            cell.playlistID = playlists[indexPath.row].id
            cell.creatorID = playlists[indexPath.row].creator
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentTableView {
        case 0:
            return TrackCell.height
        case 1:
            return PlaylistCell.height
        default:
            return 80.0
        }
    }
}

extension SenderInputViewController: UITableViewDelegate {
    
    //selecting row sets up transition to motionVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentTableView {
        case 0:
            let currentCell = tableView.cellForRow(at: indexPath) as! TrackCell
            songID = currentCell.trackID
            
            //set up and present alert to segue to motionVC
            let alertController = UIAlertController(title: "Send Song", message: "Are you sure?" , preferredStyle: .alert)
            
            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: Constants.Segue.senderInfoToMotion, sender: self)
                
            })
            let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertController.addAction(actionYes)
            alertController.addAction(actionNo)
            
            present(alertController, animated: true, completion: nil)
        case 1:
            let currentCell = tableView.cellForRow(at: indexPath) as! PlaylistCell
            playlistID = currentCell.playlistID
            creatorID = currentCell.creatorID
            
            //set up and present alert to segue to motionVC
            let alertController = UIAlertController(title: "Send Playlist", message: "Are you sure?" , preferredStyle: .alert)
            
            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: Constants.Segue.senderInfoToMotion, sender: self)
            })
            let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertController.addAction(actionYes)
            alertController.addAction(actionNo)
            
            present(alertController, animated: true, completion: nil)
        default:
            print("Non-applicable cell tapped")
        }
        
        
    }
}
