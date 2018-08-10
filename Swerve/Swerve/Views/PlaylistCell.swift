//
//  PlaylistCell.swift
//  Swerve
//
//  Created by Daniel Harris on 09/08/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit

class PlaylistCell: UITableViewCell {
    

    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var creatorName: UILabel!
    
    var playlistID: String?
    var creatorID: String?
    static let height: CGFloat = 80
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
