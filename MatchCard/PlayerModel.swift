//
//  Player.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 28/05/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

// PlayerInTeamModel means a registered player within a team in a club!

class PlayerModel : PFObjectImaged, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Player"
    }

    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
} 