//
//  MatchCard.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 01/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

class MatchCardModel : PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "MatchCard"
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
    @NSManaged var league : LeagueModel?
    @NSManaged var division : Int
    @NSManaged var date : NSDate
    @NSManaged var location : String
    @NSManaged var homeTeamBag : TeamInMatchModel
    @NSManaged var awayTeamBag : TeamInMatchModel
    @NSManaged var matchEntries : [MatchEntryModel]
    var leagueName : String {
        get {
            if let l = self.league {
                return l.Name
            }
            return "unknown"
        }
    }
    var dateString : String {
        get {
            let formatter = NSDateFormatter()
            let gbDateFormat = NSDateFormatter.dateFormatFromTemplate("dd/MM/yyyy", options: 0, locale: NSLocale(localeIdentifier: "en-GB"))
            formatter.dateFormat = gbDateFormat
            let gbSwiftDayString = formatter.stringFromDate(self.date)
            return gbSwiftDayString
        }
    }
    var homeTeamName : String {
        get {
            return self.homeTeamBag.team.Name
        }
    }
    var homeScore : String {
        get {
            return "\(self.matchEntries.reduce(0, combine: { $0 + $1.homeToken }))"
        }
    }
    var awayTeamName : String {
        get {
            return self.awayTeamBag.team.Name
        }
    }
    var awayScore : String {
        get {
            return "\(self.matchEntries.reduce(0, combine: { $0 + $1.awayToken }))"
        }
    }
    func clear() {
        self.league = nil
    }
}