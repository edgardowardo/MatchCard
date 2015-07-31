//
//  LeagueModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 03/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

/*
 Data representation of league containing a union of clubs.
*/
class LeagueModel : PFObjectImaged, PFSubclassing {
    
    static func parseClassName() -> String {
        return "League"
    }
    override init () {
        super.init()
    }
    convenience init(_ name:String, image:UIImage?, divisions:Int, clubs:[ClubInLeagueModel]?=nil)
    {
        self.init()
        self.name = name
        if let i = image {
            self.imageFile = i
        }
        self.divisions = divisions
        self.clubs = clubs
    }
    @NSManaged var divisions : Int
    @NSManaged var clubs : [ClubInLeagueModel]?
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}