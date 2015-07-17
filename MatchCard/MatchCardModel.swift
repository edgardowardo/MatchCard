//
//  MatchCard.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 01/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

/*
 Data representation of a match card.
*/
class MatchCardModel : PFObject, PFSubclassing {
    struct Prompts {
        static let League = "Set the league here"
        static let Location = "Set home venue here"
        static let Home = "Set home team here"
        static let Away = "Set away team here"
    }
    static func parseClassName() -> String {
        return "MatchCard"
    }
    override init () {
        super.init()
        addObserver(self, forKeyPath: "league", options: .New, context: nil)
        addObserver(self, forKeyPath: "homeClub", options: .New, context: nil)
    }
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        var n : AnyObject? = change["new"]
        switch keyPath {
        case "league" :
            if n!.isKindOfClass(LeagueModel) {
                var l = n as! LeagueModel
                self.teams = getAllTeams(l)
            }
        case "homeClub" :
            if n!.isKindOfClass(ClubInLeagueModel) {
                var c = n as! ClubInLeagueModel
                self.homeTeamBag.team = c.club?.teams![0]
            }
        default :
            break
        }
    }
    @NSManaged var league : LeagueModel?
    @NSManaged var division : Int
    @NSManaged var date : NSDate
    @NSManaged var homeClub : ClubInLeagueModel?
    @NSManaged var homeTeamBag : TeamInMatchModel
    @NSManaged var awayTeamBag : TeamInMatchModel
    @NSManaged var matchEntries : [MatchEntryModel]
    lazy var teams : [TeamInClubModel] = []
    func getAllTeams(fromLeague : LeagueModel) -> [TeamInClubModel] {
        var teams = [TeamInClubModel]()
        for club in fromLeague.clubs! {
            if let c = club.club {
                for team in c.teams! {
                    team.club = club
                    teams.append(team)
                }
            }
        }
        return teams
    }
    func clearLookups() {
        var matchCard = DataManager.sharedInstance.matchCard
        matchCard.homeClub = nil
        matchCard.division = 0
        matchCard.homeTeamBag.team = nil
        matchCard.awayTeamBag.team = nil
    }
    var leagueName : String {
        get {
            if let l = self.league {
                return l.name
            }
            return Prompts.League
        }
    }
    var location : String {
        get {
            if let c = self.homeClub {
                return "at " + c.club!.name
            }
            return Prompts.Location
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
            if let team = self.homeTeamBag.team {
                return team.name
            }
            return Prompts.Home
        }
    }
    var homeScore : String {
        get {
            return "\(self.matchEntries.reduce(0, combine: { $0 + $1.homeToken }))"
        }
    }
    var awayTeamName : String {
        get {
            if let team = self.awayTeamBag.team {
                return team.name
            }
            return Prompts.Away
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