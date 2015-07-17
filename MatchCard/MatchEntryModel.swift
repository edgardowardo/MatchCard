//
//  MatchEntryModel
//  MatchCard
//
//  Created by EDGARDO AGNO on 04/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

/*
 Data representation of a match entry.
*/
class MatchEntryModel : PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "MatchEntry"
    }
    override init() {
        super.init()
    }
    convenience init(homeScore : Int, awayScore : Int) {
        self.init()
        self.homeScore = homeScore
        self.awayScore = awayScore
    }
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    @NSManaged var homeKey : String
    @NSManaged var homeScore : Int
    @NSManaged var awayKey : String
    @NSManaged var awayScore : Int
    var homeToken : Int {
        get {
            return homeScore > awayScore ? 1 : 0
        }
    }
    var awayToken : Int {
        get {
            return homeScore < awayScore ? 1 : 0
        }
    }
    func clear() {
        self.homeScore = 0
        self.awayScore = 0
    }
}