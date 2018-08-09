//
//  TutorialVideoViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 09/08/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class TutorialVideoViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "SwerveTutorial", ofType:"mp4") else {
            debugPrint("SwerveTutorial.mp4 not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}
