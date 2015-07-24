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
 Association between a team within a club. We don't support a team that belongs to numerous different clubs hence there is no TeamModel to lookup to.
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
    convenience init(_ name : String, players : [PlayerInTeamModel]? = nil)
    {
        self.init()
        self.name = name
        self.players = players
    }
    @NSManaged var players : [PlayerInTeamModel]?
    var club : ClubInLeagueModel?
    var exclusion : [PlayerModel] = []
    var allPlayers : [PlayerModel]? {
        get {
            var all = [PlayerModel]()
            if let c = self.club {
                if let ps = c.club!.players {
                    for p in ps {
                        if contains(exclusion, p.player!) {
                            continue
                        }
                        all.append(p.player!)
                    }
                }
            }
            if let ps = self.players {
                for p in ps {
                    if contains(exclusion, p.player!) {
                        continue
                    }
                    all.append(p.player!)
                }
            }
            all.append(PlayerModel(name: "+", image: nil))
            return all
        }
    }
}