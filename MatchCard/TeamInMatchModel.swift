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
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    override init () {
        super.init()
    }
    convenience init(_ team : TeamInClubModel) {
        self.init()
        self.team = team
    }
    @NSManaged var team : TeamInClubModel?
    @NSManaged var total : Int
    @NSManaged var players : [PlayerInMatchModel]
}
