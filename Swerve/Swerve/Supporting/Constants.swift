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
        static let backFromSender = "backFromSender"
        static let backFromReceiver = "backFromReceiver"
        static let toInstructions = "toInstructions"
        static let toDisplayResult = "toDisplayResult"
    }

    struct UserDictionary {
        static let unselected = "unselected"
        static let sender = "sender"
        static let receiver: String = "receiver"
    }
}
