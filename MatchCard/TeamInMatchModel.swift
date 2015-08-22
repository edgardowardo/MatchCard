//
//  TeamInMatchModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 03/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

/*
 Association between a team playing in a match derived from a club. We don't support a team that belongs to numerous different clubs hence there is no TeamModel to lookup to.
*/
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
    var team : TeamInClubModel? {
        get {
            return self["team"] as? TeamInClubModel
        }
        set {
            if let t = newValue {
                self["team"] = t
            } else {
                self["team"] = NSNull()
            }
            self.clearPlayerModels()
            NSNotificationCenter.defaultCenter().postNotificationName(DataManager.Notification.Identifier.DidsetTeam, object: self)
        }
    }
    @NSManaged var total : Int
    @NSManaged var players : [PlayerInMatchModel]?
    func clearPlayerModels() {
        if let ps = self.players {
            for p in ps {
                p.player = nil
            }
        }
    }
}
