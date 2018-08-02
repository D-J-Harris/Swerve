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
    
    var receivedID = ""
    var track: Track = Track.init(name: "", artist: "", albumCoverURL: "", id: "", url: "", spotifyUri: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //having loading progress wait for the getTrack to complete
        let dispatchGroup = DispatchGroup()
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
        
        
        //Once download complete, update table view
        dispatchGroup.notify(queue: DispatchQueue.main) {
            LoadingOverlay.shared.hideOverlayView()

            self.trackName.text = self.track.name
            self.artistName.text = self.track.artist
            if let trackCoverURL = self.track.albumCoverURL {
                self.albumArtwork.af_setImage(withURL: URL(string: trackCoverURL)!)
            }
        }
    }
}
