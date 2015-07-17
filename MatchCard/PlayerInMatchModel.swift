//
//  PlayerInMatchModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 01/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

/*
 Association between a player playing in a match. It lookups to the player model and is setup by looking up from PlayerInTeam and PlayerInClub.
*/
class PlayerInMatchModel : PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "PlayerInMatch"
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
    
    init(_ key: String, _ player : PlayerModel? = nil)
    {
        super.init()
        self.player = player
        self.key = key
    }
    
    @NSManaged var player : PlayerModel?
    @NSManaged var key : String
}
