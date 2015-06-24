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
        self.Division = 1
        self.Date = NSDate()
        self.Location = "Blackley"
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var League : LeagueModel
    @NSManaged var Division : Int
    @NSManaged var Date : NSDate
    @NSManaged var Location : String
    
    @NSManaged var HomeSummary : TeamInMatchModel
    @NSManaged var AwaySummary : TeamInMatchModel // when set, set home or away
    @NSManaged var MatchEntries : [MatchEntryModel]
    
    var leagueName : String {
        get {
            return "Oldham & Rochdale Badminton League"
        }
    }
    var dateString : String {
        get {
            let formatter = NSDateFormatter()
            let gbDateFormat = NSDateFormatter.dateFormatFromTemplate("dd/MM/yyyy", options: 0, locale: NSLocale(localeIdentifier: "en-GB"))
            formatter.dateFormat = gbDateFormat
            let gbSwiftDayString = formatter.stringFromDate(self.Date)
            return gbSwiftDayString
        }
    }
}