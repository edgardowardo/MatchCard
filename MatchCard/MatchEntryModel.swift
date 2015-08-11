//
//  MatchEntryModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 06/08/2015.
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
    convenience init(_ index : Int) {
        self.init()
        self.index1s = index
    }
    convenience init(_ index : Int, homeNote: String?, homePlayer1: PlayerInMatchModel?, homePlayer2: PlayerInMatchModel?, awayNote: String?, awayPlayer1: PlayerInMatchModel?, awayPlayer2: PlayerInMatchModel?) {
        self.init()
        self.index1s = index
        
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
    @NSManaged var gameEntries : [GameEntryModel]
    @NSManaged var homePlayer1 : PlayerInMatchModel?
    @NSManaged var homePlayer2 : PlayerInMatchModel?
    @NSManaged var homeNote : String?
    @NSManaged var awayPlayer1 : PlayerInMatchModel?
    @NSManaged var awayPlayer2 : PlayerInMatchModel?
    @NSManaged var awayNote : String?
    
    var homeScore : Int {
        get {
            return self.gameEntries.reduce(0, combine: { $0 + $1.homeToken })
        }
    }
    var awayScore : Int {
        get {
            return self.gameEntries.reduce(0, combine: { $0 + $1.awayToken })
        }
    }
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
    var homeTotal : Int {
        get {
            return self.gameEntries.reduce(0, combine: { $0 + $1.homeScore })
        }
    }
    var awayTotal : Int {
        get {
            return self.gameEntries.reduce(0, combine: { $0 + $1.awayScore })
        }
    }
}