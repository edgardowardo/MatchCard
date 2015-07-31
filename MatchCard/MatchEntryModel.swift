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
    convenience init(_ index : Int, homeScore : Int, awayScore : Int, homeNote: String, _ homePlayer1: PlayerInMatchModel?, _ homePlayer2: PlayerInMatchModel?, awayNote: String, _ awayPlayer1: PlayerInMatchModel?, _ awayPlayer2: PlayerInMatchModel?) {
        self.init()
        self.index1s = index
        self.homeScore = homeScore
        self.awayScore = awayScore
        
        self.homeNote = homeNote
        self.homePlayer1 = homePlayer1
        self.homePlayer2 = homePlayer2
        
        self.awayNote = awayNote
        self.awayPlayer1 = awayPlayer1
        self.awayPlayer2 = awayPlayer2
    }
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    @NSManaged var index1s : Int
    @NSManaged var homePlayer1 : PlayerInMatchModel?
    @NSManaged var homePlayer2 : PlayerInMatchModel?
    @NSManaged var homeScore : Int
    @NSManaged var homeNote : String
    @NSManaged var awayPlayer1 : PlayerInMatchModel?
    @NSManaged var awayPlayer2 : PlayerInMatchModel?
    @NSManaged var awayScore : Int
    @NSManaged var awayNote : String
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