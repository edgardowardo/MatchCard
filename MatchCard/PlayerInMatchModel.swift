//
//  PlayerInMatchModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 01/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

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
    
    init(isAddme : Bool = false, player : PlayerModel)
    {
        super.init()
        self.IsAddme = isAddme
        self.Player = player
    }
    
    @NSManaged var IsAddme : Bool
    @NSManaged var Player : PlayerModel
    @NSManaged var Key : String
}
