//
//  LeagueModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 03/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

class LeagueModel : PFObjectImaged, PFSubclassing {
    
    static func parseClassName() -> String {
        return "League"
    }
    override init () {
        super.init()
    }
    convenience init(_ name : String, image : UIImage?, divisions : Int)
    {
        self.init()
        self.isAddme = false
        self.name = name
        if let i = image {
            self.imageFile = i
        }
        self.divisions = divisions
    }
    
    @NSManaged var divisions : Int
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}