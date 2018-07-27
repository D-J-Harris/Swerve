//
//  Constants.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation

struct Constants {
    struct Segue {
        static let senderToSenderInfo = "senderToSenderInfo"
        static let receiverToMotion = "receiverToMotion"
        static let senderInfoToMotion = "senderInfoToMotion"
    }
    struct UserDefaults {
        static let currentUser = "currentUser"
    }
    struct UserDictionary {
        static let unselected = "unselected"
        static let sender = "sender"
        static let receiver = "receiver"
    }
}