//
//  MatchCard.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 01/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

class MatchCardModel : PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "MatchCard"
    }
    
    override init () {
        super.init()
        self.Home = ""
        self.HomeTotal = 0
        self.Away = ""
        self.AwayTotal = 0
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var Home : String
    @NSManaged var HomeTotal : Int
    @NSManaged var Away : String
    @NSManaged var AwayTotal : Int
    @NSManaged var HomePlayers : [PlayerModel]
    @NSManaged var AwayPlayers : [PlayerModel]
}