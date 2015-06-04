//
//  MatchEntry.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 04/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

class MatchEntryModel : PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "MatchEntry"
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
    
    @NSManaged var HomeKey : String
    @NSManaged var HomeScore : Int
    @NSManaged var AwayKey : String
    @NSManaged var AwayScore : Int
    
    func Key() -> String {
        return self.HomeKey + self.AwayKey
    }
}