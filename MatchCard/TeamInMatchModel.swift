//
//  TeamInMatchModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 03/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

class TeamInMatchModel : PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "TeamInMatch"
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
    
    @NSManaged var isHome : Bool
    @NSManaged var team : TeamModel
    @NSManaged var total : Int
    @NSManaged var players : [PlayerInMatchModel]
}
