//
//  TrackCell.swift
//  Swerve
//
//  Created by Daniel Harris on 02/08/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit

class TrackCell: UITableViewCell {
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    var trackID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
