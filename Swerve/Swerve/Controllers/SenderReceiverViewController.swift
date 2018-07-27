//
//  SenderReceiverViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit


class SenderReceiverViewController: UIViewController {
    
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var receiverButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func senderButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "senderToSenderInfo", sender: self)
    }
    
    @IBAction func receiverButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "receiverToMotion", sender: self)
    }
    
    
    
    
}
