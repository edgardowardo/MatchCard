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
    Data representation of a team
*/
class TeamInClubModel : PFObjectImaged, PFSubclassing {
    
    static func parseClassName() -> String {
        return "TeamInClub"
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