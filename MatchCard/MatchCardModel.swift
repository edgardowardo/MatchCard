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
    enum CardType : Int {
        case Open = 0,  RoundRobin, ThreeDiscipline
        // is aggregated means there's an aggregated subgrouping against the game entries into match entries sections. so each match points are sums of each game entries        
        func isMatchPointAggregated() -> Bool {
            switch self {
            case .RoundRobin : return true
            default : return false
            }
        }
        func isRepeatedNoteSuppressed() -> Bool {
            switch self {
            case .RoundRobin :
                fallthrough
            case .ThreeDiscipline :
                return true
            default : return false
            }
        }
    }
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
        self.cardType = .Open
    }
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    var league : LeagueModel? {
        get {
            return self["league"] as? LeagueModel
        }
        set {
            if let l = newValue {
                self["league"] = l
                self.teams = getAllTeams(l)
            } else {
                self["league"] = NSNull()
                self.teams = []
            }
        }
    }
    var homeClub : ClubInLeagueModel? {
        get {
            return self["homeClub"] as? ClubInLeagueModel
        }
        set {
            if let c = newValue {
                self["homeClub"] = c
                if let homeTeam = self.homeTeamBag {
                    if homeTeam.team?.club != c {
                        homeTeam.team = c.club?.teams![0]
                        homeTeam.clearPlayerModels()
                    }
                }
            } else {
                self["homeClub"] = NSNull()
                if let homeTeam = self.homeTeamBag {
                    homeTeam.clearPlayerModels()
                }
            }
        }
    }
    var cardType : CardType? {
        get {
            return CardType(rawValue: self["cardType"] as! Int)
        }
        set {
            if let t = newValue {
                self["cardType"] = t.rawValue
            } else {
                self["cardType"] = NSNull()
            }
        }
    }
    @NSManaged var division : Int
    @NSManaged var date : NSDate
    @NSManaged var homeTeamBag : TeamInMatchModel?
    @NSManaged var awayTeamBag : TeamInMatchModel
    @NSManaged var matchEntries : [MatchEntryModel]
    lazy var teams : [TeamInClubModel] = []
    lazy var mockedHomePairs : [PlayerModel] = self.buildMockedPairs(fromPlayingTeam : self.homeTeamBag!)
    lazy var mockedAwayPairs : [PlayerModel] = self.buildMockedPairs(fromPlayingTeam : self.awayTeamBag)
    // TODO: if the list is changed in edit mode, the above initialisation must be refreshed!
    /* Build the pairs form the current playing team. We know that there are 3 pairs in a team  */
    func buildMockedPairs(fromPlayingTeam team : TeamInMatchModel) -> [PlayerModel] {
        var mockedPlayers : [PlayerModel] = []
        if let players = team.players {
            for var i = 0; i < players.count / 2; i++ {
                let p1 = team.players?[i*2].player!
                let p2 = team.players?[i*2 + 1].player!
                let w = CGFloat(160)
                let h = CGFloat(160)
                
                // Some core graphics manipulation
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0)
                var context = UIGraphicsGetCurrentContext()
                if let image1 = p1?.imageFile {
                    let leftImage = UIImage(CGImage: CGImageCreateWithImageInRect(image1.CGImage, CGRectMake(w/4-2, CGFloat(0), w/2-2, h)))
                    leftImage?.drawInRect(CGRectMake(CGFloat(0), CGFloat(0), w/2-4, h))
                }
                if let image2 = p2?.imageFile {
                    let rightImage = UIImage(CGImage: CGImageCreateWithImageInRect(image2.CGImage, CGRectMake(w/4-2, CGFloat(0), w/2-2, h)))
                    rightImage?.drawInRect(CGRectMake(w/2+4, CGFloat(0), w/2, h))
                }
                let combinedImgRef = CGBitmapContextCreateImage(context)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let p1Name = p1!.name
                let p2Name = p2!.name
                let p1Name3 = ( count(p1Name) > 3 ? p1Name.substringToIndex(advance(p1Name.startIndex, 3)) : p1Name )
                let p2Name3 = ( count(p2Name) > 3 ? p2Name.substringToIndex(advance(p2Name.startIndex, 3)) : p2Name )
                let mockedName = "\(p1Name3) / \(p2Name3)"
                let mockedPlayer = PlayerModel(name: mockedName, image: newImage)
                mockedPlayers.append(mockedPlayer)
            }
        }
        return mockedPlayers
    }
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
        matchCard.homeTeamBag!.team = nil
        matchCard.homeTeamBag!.clearPlayerModels()
        matchCard.awayTeamBag.team = nil
        matchCard.awayTeamBag.clearPlayerModels()
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
            if let team = self.homeTeamBag!.team {
                return team.name
            }
            return Prompts.Home
        }
    }
    var homeScore : Int {
        get {
            if let type = cardType {
                if type.isMatchPointAggregated() {
                    return self.matchEntries.reduce(0, combine: { $0 + $1.homeToken })
                } else {
                    return self.matchEntries.reduce(0, combine: { $0 + $1.homeScore })
                }
            } else {
                return 0
            }
        }
    }
    var homeTotal : Int {
        get {
            return self.matchEntries.reduce(0, combine: { $0 + $1.homeTotal })
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
    var awayScore : Int {
        get {
            if let type = cardType {
                if type.isMatchPointAggregated() {
                    return self.matchEntries.reduce(0, combine: { $0 + $1.awayToken })
                } else {
                    return self.matchEntries.reduce(0, combine: { $0 + $1.awayScore })
                }
            } else {
                return 0
            }
        }
    }
    var awayTotal : Int {
        get {
            return self.matchEntries.reduce(0, combine: { $0 + $1.awayTotal })
        }
    }
    func clear() {
        self.league = nil
    }    
}