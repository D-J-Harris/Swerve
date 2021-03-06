//
//  DisplayResultViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 29/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class DisplayResultViewController: UIViewController {
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var openInSpotifyButton: UIButton!
    @IBOutlet weak var addToSpotifyButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    //Empty initialisations
    var receivedID = ""
    var receivedSpotifyMatchedID = ""
    var currentSpotifyID = ""
    //Initialisation of empty incoming instances
    var track: Track = Track.init(name: "", artist: "", albumCoverURL: "", id: "", url: "", spotifyUri: "")
    var playlist: Playlist = Playlist.init(name: "", creator: "", id: "", url: "", spotifyUri: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()
        
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor(displayP3Red: 0.431, green: 0.918, blue: 0.667, alpha: 1).cgColor,
                           UIColor(displayP3Red: 0.961, green: 0.408, blue: 0.349, alpha: 1).cgColor,
                           UIColor(displayP3Red: 0.878, green: 0.898, blue: 0.243, alpha: 1).cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        trackName.layer.masksToBounds = true
        artistName.layer.masksToBounds = true
        openInSpotifyButton.layer.masksToBounds = true
        addToSpotifyButton.layer.masksToBounds = true
        trackName.layer.cornerRadius = 9
        artistName.layer.cornerRadius = 9
        openInSpotifyButton.layer.cornerRadius = 5
        addToSpotifyButton.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //having loading progress wait for the getTrack to complete
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        LoadingOverlay.shared.showOverlay(self.view)
        getTrack(trackID: receivedID) { (track) in
            if track.name != "" {
                print("track downloaded")
                self.track = track
            }
            else {
                print("no track exists")
            }
            dispatchGroup.leave()
        }
        
        if track.name == "" {
            getPlaylist(playlistID: receivedID, receivedSpotifyMatchedID) { (playlist) in
                if playlist.name != "" {
                    print("playlist downloaded")
                    self.playlist = playlist
                }
                else {
                    print("no playlist exists")
                }
                dispatchGroup.leave()
            }
        } else {dispatchGroup.leave()}
        
        
        //Once download complete, update track info
        dispatchGroup.notify(queue: DispatchQueue.main) {
            LoadingOverlay.shared.hideOverlayView(self.view)
            
            
            if self.track.name != "" {
                self.trackName.text = self.track.name
                self.artistName.text = self.track.artist
                guard let albumCoverURL = self.track.albumCoverURL else {return}
                if albumCoverURL != "" {
                    self.albumArtwork.af_setImage(withURL: URL(string: self.track.albumCoverURL!)!)
                }
            } else if self.playlist.name != "" {
                self.trackName.text = self.playlist.name
                self.artistName.text = self.playlist.creator
                self.albumArtwork.image = #imageLiteral(resourceName: "Swerve Logo")
            }
            else {
                //Alert the user that no song was transferred
                let alert = UIAlertController(title: nil, message: "No song found!", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: Constants.Segue.displayResultsToMotion, sender: self)
                })
                alert.addAction(actionOK)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func openInSpotifyButtonTapped(_ sender: UIButton) {
        //check if spotify installed
        if SPTAuth.supportsApplicationAuthentication() {
            //app login
            if track.url != "" {
                UIApplication.shared.open(URL(string: track.spotifyUri)!, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.open(URL(string: playlist.spotifyUri)!, options: [:], completionHandler: nil)
            }
        }
        else {
            //web login
            if track.url != "" {
                UIApplication.shared.open(URL(string: track.url)!, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.open(URL(string: playlist.url)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func addToSpotifyButtonTapped(_ sender: UIButton) {
        
        //if song passed
        if track.id != "" {
            addSongToSpotify(songID: track.id)
        }
        //if playlist passed
        else {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            getCurrentSpotifyID { (id) in
                guard let id = id else{dispatchGroup.leave(); return}
                self.currentSpotifyID = id
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                addPlaylistToSpotify(playlistID: self.playlist.id, self.currentSpotifyID)
            }
        }
        
    }
    
}
