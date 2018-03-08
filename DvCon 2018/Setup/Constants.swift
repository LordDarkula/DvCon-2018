//
//  DatabseConstants.swift
//  DvCon 2018
//
//  Created by Aubhro Sengupta on 8/29/17.
//  Copyright © 2018 Aubhro Sengupta. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBConstants {
    static let eventName   = "DVCon 2018"
    static let dateKey     = "DateKey"
    static let timeKey     = "TimeKey"
    static let talkKey     = "Date"
    static let sponsorsKey = "sponsorsKey"
    
    static let rootRef = Database.database().reference().child(DBConstants.eventName)
}

class CellIdentifiers {
    static let talkList = "TalkCell"
    static let myList   = "SavedCell"
    static let sponsors = "SponsorCell"
}
