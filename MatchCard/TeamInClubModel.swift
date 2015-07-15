//
//  TeamModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 03/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

/*
    Data representation of a team associated to a club. We don't support a team that belongs to numerous different clubs 
    hence there is no TeamModel.
*/
class TeamInClubModel : PFObjectImaged, PFSubclassing {
    static func parseClassName() -> String {
        return "TeamInClub"
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
    convenience init(_ name : String)
    {
        self.init()
        self.isAddme = false
        self.name = name
    }
    var club : ClubInLeagueModel?
}