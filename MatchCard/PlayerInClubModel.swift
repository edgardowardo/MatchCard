//
//  PlayerInClubModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 17/07/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

/*
 Association between a player registered within a team in a club. It looks up to the player model for reference data. This assoiation is a lookup list when setting up a player playing in a match.
*/
class PlayerInClubModel : PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "PlayerInClub"
    }
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    override init () {
        super.init()
    }
    convenience init(_ player : PlayerModel)
    {
        self.init()
        self.player = player
    }
    var player : PlayerModel?
}