//
//  GameEntryModel
//  MatchCard
//
//  Created by EDGARDO AGNO on 04/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

/*
 Data representation of a game entry.
*/
class GameEntryModel : PFObject, PFSubclassing {
    enum Incident : Int {
        case Disqualified=31, Retired, Walkover
        func shortName() -> String {
            switch self {
            case .Disqualified : return "D"
            case .Retired : return "R"
            case .Walkover : return "W"
            default :
                assertionFailure("unknown incident!")
            }
        }
        static func longName(incident : Incident) -> String {
            switch incident {
            case .Disqualified : return "Disqualified"
            case .Retired : return "Retired"
            case .Walkover : return "Walkover"
            default :
                assertionFailure("unknown incident!")
            }
        }
        func tokenValue() -> Int {
            switch self {
            case .Disqualified : return 0
            case .Retired : return 0
            case .Walkover : return 1
            default :
                assertionFailure("unknown incident!")
            }
        }
        func tokenInverse() -> Int {
            if self.tokenValue() == 0 {
                return 1
            } else {
                return 0
            }
        }
    }
    static func parseClassName() -> String {
        return "GameEntry"
    }
    override init() {
        super.init()
    }
    convenience init(_ index : Int, homeScore : Int, awayScore : Int) {
        self.init()
        self.index1s = index
        self.homeScore = homeScore
        self.awayScore = awayScore
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
    @NSManaged var homeNote : String?
    @NSManaged var homePlayer1 : PlayerInMatchModel?
    @NSManaged var homePlayer2 : PlayerInMatchModel?
    var homeEntry : String {
        get {
            if let hi = homeIncident {
                return hi.shortName()
            } else {
                return "\(homeScore)"
            }
        }
    }
    var homeScore : Int {
        get {
            return self["homeScore"] as! Int
        }
        set {
            self["homeScore"] = newValue
            homeIncident = nil
        }
    }
    var homeIncident : Incident? {
        get {
            if self["homeIncident"] is NSNull {
                return nil
            } else {
                return Incident(rawValue: self["homeIncident"] as! Int)
            }
        }
        set {
            if let i = newValue {
                self["homeIncident"] = i.rawValue
            } else {
                self["homeIncident"] = NSNull()
            }
        }
    }
    var homeToken : Int {
        get {
            if let hi = homeIncident {
                return hi.tokenValue()
            }
            if let ai = awayIncident {
                return ai.tokenInverse()
            }
            return homeScore > awayScore ? 1 : 0
        }
    }
    @NSManaged var awayNote : String?
    @NSManaged var awayPlayer1 : PlayerInMatchModel?
    @NSManaged var awayPlayer2 : PlayerInMatchModel?
    var awayEntry : String {
        get {
            if let hi = awayIncident {
                return hi.shortName()
            } else {
                return "\(awayScore)"
            }
        }
    }
    var awayScore : Int {
        get {
            return self["awayScore"] as! Int
        }
        set {
            self["awayScore"] = newValue
            awayIncident = nil
        }
    }
    var awayIncident : Incident? {
        get {
            if self["awayIncident"] is NSNull {
                return nil
            } else {
                return Incident(rawValue: self["awayIncident"] as! Int)
            }
        }
        set {
            if let i = newValue {
                self["awayIncident"] = i.rawValue
            } else {
                self["awayIncident"] = NSNull()
            }
        }
    }
    var awayToken : Int {
        get {
            if let ai = awayIncident {
                return ai.tokenValue()
            }
            if let hi = homeIncident {
                return hi.tokenInverse()
            }
            return homeScore < awayScore ? 1 : 0
        }
    }
    func setScores(home : Int,_ away : Int) {
        self.homeScore = home
        self.awayScore = away
    }
    func clear() {
        self.homeScore = 0
        self.awayScore = 0
    }
}