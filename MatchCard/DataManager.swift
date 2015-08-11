//
//  DataManager.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 26/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

class DataManager {
    static let sharedInstance = DataManager()
    lazy var allLeagues = DataManager.sharedInstance.getAllLeagues()
    lazy var allClubs = DataManager.sharedInstance.getAllClubs()
    lazy var allPlayers = DataManager.sharedInstance.getAllPlayers()
    lazy var matchCard = DataManager.sharedInstance.newMatchCard_RoundRobin(true) //.newMatchCard_RoundRobin() //.newMatchCard_Open() // .newMatchCard_3Discipline()
    
    func loadMatchCard_3Discipline(mc: MatchCardModel) {
        if mc.cardType == .ThreeDiscipline {
            let l = allLeagues[1]       // Manchester Badminton League
            let c = l.clubs![6]         // Shire
            let t = c.club?.teams![0]   // Shire1
            mc.division = 2
            mc.league = l
            mc.homeClub = c

            mc.homeTeamBag!.team = t    // Shire1
            mc.homeTeamBag!.players![0].player = getElement(allPlayers, withName: "Edgar")
            mc.homeTeamBag!.players![1].player = getElement(allPlayers, withName: "Slawomir")
            mc.homeTeamBag!.players![2].player = getElement(allPlayers, withName: "Kristof")
            mc.homeTeamBag!.players![3].player = getElement(allPlayers, withName: "Khai")
            mc.homeTeamBag!.players![4].player = getElement(allPlayers, withName: "Pete")
            mc.homeTeamBag!.players![5].player = getElement(allPlayers, withName: "Someguy")
            
            mc.awayTeamBag.team = l.clubs![7].club?.teams![1]  // Heys-B
            mc.awayTeamBag.players![0].player = getElement(allPlayers, withName: "Slaw")
            mc.awayTeamBag.players![1].player = getElement(allPlayers, withName: "Peter")
            mc.awayTeamBag.players![2].player = getElement(allPlayers, withName: "Liza Doolittle")
            mc.awayTeamBag.players![3].player = getElement(allPlayers, withName: "Simon Sack")
            mc.awayTeamBag.players![4].player = getElement(allPlayers, withName: "Mark Zuckerberg")
            mc.awayTeamBag.players![5].player = getElement(allPlayers, withName: "Paul")
            
            mc.matchEntries[0].gameEntries[0].setScores(21, 18)
            mc.matchEntries[0].gameEntries[1].setScores(21, 16)
            mc.matchEntries[1].gameEntries[0].setScores(21, 14)
            mc.matchEntries[1].gameEntries[1].setScores(21, 17)
            mc.matchEntries[2].gameEntries[0].setScores(22, 24)
            mc.matchEntries[2].gameEntries[1].setScores(21, 23)
            mc.matchEntries[3].gameEntries[0].setScores(21, 19)
            mc.matchEntries[3].gameEntries[1].setScores(24, 22)
            mc.matchEntries[4].gameEntries[0].setScores(17, 21)
            mc.matchEntries[4].gameEntries[1].setScores(20, 22)
            mc.matchEntries[5].gameEntries[0].setScores(15, 21)
            mc.matchEntries[5].gameEntries[1].setScores(13, 21)
            mc.matchEntries[6].gameEntries[0].setScores(25, 23)
            mc.matchEntries[6].gameEntries[1].setScores(24, 22)
            mc.matchEntries[7].gameEntries[0].setScores(18, 21)
            mc.matchEntries[7].gameEntries[1].setScores(21, 16)
            mc.matchEntries[8].gameEntries[0].setScores(21, 10)
            mc.matchEntries[8].gameEntries[1].setScores(21, 23)
            
        } else {
            assertionFailure("loading the wrong type")
        }
    }
    
    func loadMatchCard_Open(mc : MatchCardModel) {
        if mc.cardType == .Open {
            let l = allLeagues[1]       // Manchester Badminton League
            let c = l.clubs![6]         // Shire
            let t = c.club?.teams![0]   // Shire1
            mc.division = 2
            mc.league = l
            mc.homeClub = c
            mc.homeTeamBag!.team = t    // Shire1
            mc.homeTeamBag!.players![0].player = getElement(allPlayers, withName: "Edgar")
            mc.awayTeamBag.team = l.clubs![7].club?.teams![1]  // Heys-B
            mc.awayTeamBag.players![1].player = getElement(allPlayers, withName: "Slaw")
            for var i = 0; i < 18; i++ {
                var game = mc.matchEntries[0].gameEntries[i] as GameEntryModel
                switch i {
                case 0: game.setScores(10, 21)
                case 1: game.setScores(14, 21)
                case 2: game.setScores(18, 21)
                case 3: game.setScores(19, 21)
                case 4: game.setScores(21, 19)
                case 5: game.setScores(21, 18)
                case 6: game.setScores(16, 21)
                case 7: game.setScores(18, 21)
                case 8: game.setScores(16, 21)
                case 9: game.setScores(09, 21)
                case 10: game.setScores(06, 21)
                case 11: game.setScores(19, 21)
                case 12: game.setScores(15, 21)
                case 13: game.setScores(02, 21)
                case 14: game.setScores(04, 21)
                case 15: game.setScores(19, 21)
                case 16: game.setScores(16, 21)
                case 17: game.setScores(15, 21)
                default :
                    assertionFailure("you went out of bounds")
                }
            }
        } else {
            assertionFailure("loading the wrong type")
        }
    }
    
    func loadMatchCard_RoundRobin(mc: MatchCardModel) {
        if mc.cardType == .RoundRobin {
            let l = allLeagues[1]       // Someshire Badminton League
            let c = l.clubs![6]         // Shire
            let t = c.club?.teams![0]   // Shire1
            mc.division = 1
            mc.league = l
            mc.homeClub = c
            mc.homeTeamBag!.team = t    // Shire1
            mc.homeTeamBag!.players![0].player = getElement(allPlayers, withName: "Edgar")
            mc.homeTeamBag!.players![1].player = getElement(allPlayers, withName: "Slawomir")
            mc.homeTeamBag!.players![2].player = getElement(allPlayers, withName: "Kristof")
            mc.homeTeamBag!.players![3].player = getElement(allPlayers, withName: "Khai")
            mc.homeTeamBag!.players![4].player = getElement(allPlayers, withName: "Pete")
            mc.homeTeamBag!.players![5].player = getElement(allPlayers, withName: "Someguy")
            
            mc.awayTeamBag.team = l.clubs![7].club?.teams![1]  // Heys-B
            mc.awayTeamBag.players![0].player = getElement(allPlayers, withName: "Slaw")
            mc.awayTeamBag.players![1].player = getElement(allPlayers, withName: "Peter")
            mc.awayTeamBag.players![2].player = getElement(allPlayers, withName: "Liza Doolittle")
            mc.awayTeamBag.players![3].player = getElement(allPlayers, withName: "Simon Sack")
            mc.awayTeamBag.players![4].player = getElement(allPlayers, withName: "Mark Zuckerberg")
            mc.awayTeamBag.players![5].player = getElement(allPlayers, withName: "Paul")

            // match entries and games being a matrix
            // home row 1
            mc.matchEntries[0].gameEntries[0].setScores(21, 13)
            mc.matchEntries[0].gameEntries[1].setScores(21, 16)
            mc.matchEntries[1].gameEntries[0].setScores(16, 21)
            mc.matchEntries[1].gameEntries[1].setScores(21, 11)
            mc.matchEntries[1].gameEntries[2].setScores(21, 18)
            mc.matchEntries[2].gameEntries[0].setScores(21, 14)
            mc.matchEntries[2].gameEntries[1].setScores(21, 15)

            // home row 2
            mc.matchEntries[3].gameEntries[0].setScores(18, 21)
            mc.matchEntries[3].gameEntries[1].setScores(17, 21)
            mc.matchEntries[4].gameEntries[0].setScores(11, 21)
            mc.matchEntries[4].gameEntries[1].setScores(22, 20)
            mc.matchEntries[4].gameEntries[2].setScores(21, 18)
            mc.matchEntries[5].gameEntries[0].setScores(23, 21)
            mc.matchEntries[5].gameEntries[1].setScores(21, 13)
            
            // home row 3
            mc.matchEntries[6].gameEntries[0].setScores(21, 8)
            mc.matchEntries[6].gameEntries[1].setScores(21, 9)
            mc.matchEntries[7].gameEntries[0].setScores(21, 15)
            mc.matchEntries[7].gameEntries[1].setScores(21, 13)
            mc.matchEntries[8].gameEntries[0].setScores(21, 12)
            mc.matchEntries[8].gameEntries[1].setScores(21, 12)

        } else {
            assertionFailure("loading the wrong type")
        }
    }
    
    func newMatchCard_3Discipline(_ loadSample : Bool = false) -> MatchCardModel {
        var mc = MatchCardModel()
        mc.cardType = .ThreeDiscipline
        mc.date = NSDate()
        mc.homeTeamBag = TeamInMatchModel()
        mc.homeTeamBag!.players = [
            PlayerInMatchModel("MA"),
            PlayerInMatchModel("MB"),
            PlayerInMatchModel("MC"),
            PlayerInMatchModel("WA"),
            PlayerInMatchModel("WB"),
            PlayerInMatchModel("WC")
        ]
        mc.awayTeamBag = TeamInMatchModel()
        mc.awayTeamBag.players = [
            PlayerInMatchModel("MA"),   //0
            PlayerInMatchModel("MB"),   //1
            PlayerInMatchModel("MC"),   //2
            PlayerInMatchModel("WA"),   //3
            PlayerInMatchModel("WB"),   //4
            PlayerInMatchModel("WC")    //5
        ]
        let homeTeam = mc.homeTeamBag!
        let awayTeam = mc.awayTeamBag
        mc.matchEntries = []
        var idx1 = 0
        // Create the match entries
        for var i = 0; i < 9; i++ {
            var isNoteSame = true
            var homeNote = "N/A"
            var awayNote = "N/A"
            var homePlayer1 : PlayerInMatchModel?
            var homePlayer2 : PlayerInMatchModel?
            var awayPlayer1 : PlayerInMatchModel?
            var awayPlayer2 : PlayerInMatchModel?
            
            switch i {
            case 0 :
                homeNote = "MD-AB"
                homePlayer1 = homeTeam.players![0]
                homePlayer2 = homeTeam.players![1]
                awayPlayer1 = awayTeam.players![0]
                awayPlayer2 = awayTeam.players![1]
            case 1 :
                homeNote = "WD-AB"
                homePlayer1 = homeTeam.players![3]
                homePlayer2 = homeTeam.players![4]
                awayPlayer1 = awayTeam.players![3]
                awayPlayer2 = awayTeam.players![4]
            case 2 :
                homeNote = "MD-AC"
                homePlayer1 = homeTeam.players![0]
                homePlayer2 = homeTeam.players![2]
                awayPlayer1 = awayTeam.players![0]
                awayPlayer2 = awayTeam.players![2]
            case 3 :
                homeNote = "WD-AC"
                homePlayer1 = homeTeam.players![3]
                homePlayer2 = homeTeam.players![5]
                awayPlayer1 = awayTeam.players![3]
                awayPlayer2 = awayTeam.players![5]
            case 4 :
                homeNote = "XD-B"
                homePlayer1 = homeTeam.players![1]
                homePlayer2 = homeTeam.players![4]
                awayPlayer1 = awayTeam.players![1]
                awayPlayer2 = awayTeam.players![4]
            case 5 :
                homeNote = "XD-C"
                homePlayer1 = homeTeam.players![2]
                homePlayer2 = homeTeam.players![5]
                awayPlayer1 = awayTeam.players![2]
                awayPlayer2 = awayTeam.players![5]
            case 6 :
                homeNote = "XD-A"
                homePlayer1 = homeTeam.players![0]
                homePlayer2 = homeTeam.players![3]
                awayPlayer1 = awayTeam.players![0]
                awayPlayer2 = awayTeam.players![3]
            case 7 :
                homeNote = "XD-C"
                awayNote = "XD-B"
                homePlayer1 = homeTeam.players![2]
                homePlayer2 = homeTeam.players![5]
                awayPlayer1 = awayTeam.players![1]
                awayPlayer2 = awayTeam.players![4]
                isNoteSame = false
            case 8 :
                homeNote = "XD-B"
                awayNote = "XD-C"
                homePlayer1 = homeTeam.players![1]
                homePlayer2 = homeTeam.players![4]
                awayPlayer1 = awayTeam.players![2]
                awayPlayer2 = awayTeam.players![5]
                isNoteSame = false
            default :
                homeNote = "coding error"
                awayNote = "coding error"
            }
            
            if isNoteSame {
                awayNote = homeNote
            }
            
            var matchEntry = MatchEntryModel(++idx1, homeNote: homeNote,  homePlayer1: homePlayer1, homePlayer2: homePlayer2, awayNote: awayNote, awayPlayer1: awayPlayer1, awayPlayer2: awayPlayer2)
            matchEntry.gameEntries = []
            matchEntry.gameEntries.append(GameEntryModel(1, homeScore: 0, awayScore:0))
            matchEntry.gameEntries.append(GameEntryModel(2, homeScore: 0, awayScore:0))
            mc.matchEntries.append(matchEntry)
        }
        
        if loadSample {
            loadMatchCard_3Discipline(mc)
        }
        return mc
    }
    
    func newMatchCard_Open(_ loadSample : Bool = false) -> MatchCardModel {
        var mc = MatchCardModel()
        mc.cardType = .Open
        mc.date = NSDate()
        mc.homeTeamBag = TeamInMatchModel()
        mc.homeTeamBag!.players = [
            PlayerInMatchModel("A1"),
            PlayerInMatchModel("A2"),
            PlayerInMatchModel("B3"),
            PlayerInMatchModel("B4"),
            PlayerInMatchModel("C5"),
            PlayerInMatchModel("C6")
        ]
        mc.awayTeamBag = TeamInMatchModel()
        mc.awayTeamBag.players = [
            PlayerInMatchModel("A1"),
            PlayerInMatchModel("A2"),
            PlayerInMatchModel("B3"),
            PlayerInMatchModel("B4"),
            PlayerInMatchModel("C5"),
            PlayerInMatchModel("C6")
        ]
        
        let homeTeam = mc.homeTeamBag!
        let awayTeam = mc.awayTeamBag
        
        let matchEntry = MatchEntryModel(1)
        mc.matchEntries = []
        mc.matchEntries.append(matchEntry)

        matchEntry.gameEntries = []
        matchEntry.gameEntries.append(GameEntryModel(01, homeScore: 0, awayScore: 0, homeNote: "1&3",  homeTeam.players![0], homeTeam.players![2], awayNote: "1&3", awayTeam.players![0], awayTeam.players![2]))
        matchEntry.gameEntries.append(GameEntryModel(02, homeScore: 0, awayScore: 0, homeNote: "2&5",  homeTeam.players![1], homeTeam.players![4], awayNote: "2&5", awayTeam.players![1], awayTeam.players![4]))
        matchEntry.gameEntries.append(GameEntryModel(03, homeScore: 0, awayScore: 0, homeNote: "4&6",  homeTeam.players![3], homeTeam.players![5], awayNote: "4&6", awayTeam.players![3], awayTeam.players![5]))
        matchEntry.gameEntries.append(GameEntryModel(04, homeScore: 0, awayScore: 0, homeNote: "3&5",  homeTeam.players![2], homeTeam.players![4], awayNote: "3&5", awayTeam.players![2], awayTeam.players![4]))
        matchEntry.gameEntries.append(GameEntryModel(05, homeScore: 0, awayScore: 0, homeNote: "1&4",  homeTeam.players![0], homeTeam.players![3], awayNote: "1&4", awayTeam.players![0], awayTeam.players![3]))
        matchEntry.gameEntries.append(GameEntryModel(06, homeScore: 0, awayScore: 0, homeNote: "2&6",  homeTeam.players![1], homeTeam.players![5], awayNote: "2&6", awayTeam.players![1], awayTeam.players![5]))
        matchEntry.gameEntries.append(GameEntryModel(07, homeScore: 0, awayScore: 0, homeNote: "B",  homeTeam.players![2], homeTeam.players![3], awayNote: "A", awayTeam.players![0], awayTeam.players![1]))
        matchEntry.gameEntries.append(GameEntryModel(08, homeScore: 0, awayScore: 0, homeNote: "A",  homeTeam.players![0], homeTeam.players![1], awayNote: "C", awayTeam.players![4], awayTeam.players![5]))
        matchEntry.gameEntries.append(GameEntryModel(09, homeScore: 0, awayScore: 0, homeNote: "C",  homeTeam.players![4], homeTeam.players![5], awayNote: "B", awayTeam.players![3], awayTeam.players![4]))
        matchEntry.gameEntries.append(GameEntryModel(10, homeScore: 0, awayScore: 0, homeNote: "B",  homeTeam.players![2], homeTeam.players![3], awayNote: "C", awayTeam.players![4], awayTeam.players![5]))
        matchEntry.gameEntries.append(GameEntryModel(11, homeScore: 0, awayScore: 0, homeNote: "C",  homeTeam.players![4], homeTeam.players![5], awayNote: "A", awayTeam.players![0], awayTeam.players![1]))
        matchEntry.gameEntries.append(GameEntryModel(12, homeScore: 0, awayScore: 0, homeNote: "A",  homeTeam.players![0], homeTeam.players![1], awayNote: "B", awayTeam.players![2], awayTeam.players![3]))
        matchEntry.gameEntries.append(GameEntryModel(13, homeScore: 0, awayScore: 0, homeNote: "C",  homeTeam.players![4], homeTeam.players![5], awayNote: "C", awayTeam.players![4], awayTeam.players![5]))
        matchEntry.gameEntries.append(GameEntryModel(14, homeScore: 0, awayScore: 0, homeNote: "C",  homeTeam.players![4], homeTeam.players![5], awayNote: "C", awayTeam.players![4], awayTeam.players![5]))
        matchEntry.gameEntries.append(GameEntryModel(15, homeScore: 0, awayScore: 0, homeNote: "B",  homeTeam.players![2], homeTeam.players![3], awayNote: "B", awayTeam.players![2], awayTeam.players![3]))
        matchEntry.gameEntries.append(GameEntryModel(16, homeScore: 0, awayScore: 0, homeNote: "B",  homeTeam.players![2], homeTeam.players![3], awayNote: "B", awayTeam.players![2], awayTeam.players![3]))
        matchEntry.gameEntries.append(GameEntryModel(17, homeScore: 0, awayScore: 0, homeNote: "A",  homeTeam.players![0], homeTeam.players![1], awayNote: "A", awayTeam.players![0], awayTeam.players![1]))
        matchEntry.gameEntries.append(GameEntryModel(18, homeScore: 0, awayScore: 0, homeNote: "A",  homeTeam.players![0], homeTeam.players![1], awayNote: "A", awayTeam.players![0], awayTeam.players![1]))
        
        if loadSample {
            loadMatchCard_Open(mc)
        }
        
        return mc
    }
    
    func newMatchCard_RoundRobin(_ loadSample : Bool = false) -> MatchCardModel {
        var mc = MatchCardModel()
        mc.cardType = .RoundRobin
        mc.date = NSDate()
        mc.homeTeamBag = TeamInMatchModel()
        mc.homeTeamBag!.players = [
            PlayerInMatchModel("A"),
            PlayerInMatchModel("A"),
            PlayerInMatchModel("B"),
            PlayerInMatchModel("B"),
            PlayerInMatchModel("C"),
            PlayerInMatchModel("C")
        ]
        mc.awayTeamBag = TeamInMatchModel()
        mc.awayTeamBag.players = [
            PlayerInMatchModel("A"),
            PlayerInMatchModel("A"),
            PlayerInMatchModel("B"),
            PlayerInMatchModel("B"),
            PlayerInMatchModel("C"),
            PlayerInMatchModel("C")
        ]
        let homeTeam = mc.homeTeamBag!
        let awayTeam = mc.awayTeamBag
        mc.matchEntries = []
        func getNote(fromIndex : Int) -> String {
            switch fromIndex {
            case 0 : return "A"
            case 1 : return "B"
            case 2 : return "C"
            default :
                assertionFailure("you are out of bounds")
                return ""
            }
        }
        var idx1 = 0
        // Create the matrix
        for var i = 0; i < homeTeam.players!.count / 2; i++ {
            var homeNote =  getNote(i)
            let homePlayer1 = homeTeam.players![i*2]
            let homePlayer2 = homeTeam.players![i*2+1]
            for var j = 0; j < awayTeam.players!.count / 2; j++ {
                var awayNote =  getNote(j)
                let awayPlayer1 = awayTeam.players![j*2]
                let awayPlayer2 = awayTeam.players![j*2+1]
                var matchEntry = MatchEntryModel(++idx1, homeNote: homeNote,  homePlayer1: homePlayer1, homePlayer2: homePlayer2, awayNote: awayNote, awayPlayer1: awayPlayer1, awayPlayer2: awayPlayer2)
                matchEntry.gameEntries = []
                matchEntry.gameEntries.append(GameEntryModel(1, homeScore: 0, awayScore:0))
                matchEntry.gameEntries.append(GameEntryModel(2, homeScore: 0, awayScore:0))
                matchEntry.gameEntries.append(GameEntryModel(3, homeScore: 0, awayScore:0))
                mc.matchEntries.append(matchEntry)
            }
        }
        if loadSample {
            loadMatchCard_RoundRobin(mc)
        }
        return mc
    }
    
    func getAllPlayers() -> [PlayerModel] {
        return [
            PlayerModel(name: "Edgar", image: UIImage(named: "edgar")),
            PlayerModel(name: "Slawomir", image: UIImage(named: "slavo")),
            PlayerModel(name: "Someguy", image: UIImage(named: "watch")),
            PlayerModel(name: "Khai", image: UIImage(named: "khai")),
            PlayerModel(name: "Pete", image: UIImage(named: "pete")),
            PlayerModel(name: "Simon Sack", image: nil),
            PlayerModel(name: "Liza Doolittle", image: nil),
            PlayerModel(name: "Kristof", image: nil),
            PlayerModel(name: "Slaw", image: UIImage(named: "slaw")),
            PlayerModel(name: "Mark Zuckerberg", image: UIImage(named: "markZ")),
            PlayerModel(name: "Peter", image: UIImage(named: "peter")),
            PlayerModel(name: "Paul", image: UIImage(named: "paul"))
        ]
    }
    
    func getElement<T:PFObject>  (fromArray:[T], withName:String) -> T? {
        let filteredArray = fromArray.filter() {
            if let type = ($0 as PFObject)["name"] as? String {
                return type == withName
            } else {
                return false
            }
        }
        if filteredArray.count > 0 {
            return filteredArray[0]
        }
        return nil
    }
    
    func getAllClubs() -> [ClubModel] {
        // Shire players
        let clubShirePlayers = [
            PlayerInClubModel(getElement(allPlayers, withName: "Edgar")!),
            PlayerInClubModel(getElement(allPlayers, withName: "Slawomir")!),
            PlayerInClubModel(getElement(allPlayers, withName: "Kristof")!)]
        let teamShire1Players = [
            PlayerInTeamModel(getElement(allPlayers, withName: "Khai")!),
            PlayerInTeamModel(getElement(allPlayers, withName: "Pete")!),
            PlayerInTeamModel(getElement(allPlayers, withName: "Someguy")!)]
        
        // Heys players
        let clubHeysPlayers = [
            PlayerInClubModel(getElement(allPlayers, withName: "Mark Zuckerberg")!),
            PlayerInClubModel(getElement(allPlayers, withName: "Liza Doolittle")!)]
        let teamHeysBPlayers = [
            PlayerInTeamModel(getElement(allPlayers, withName: "Simon Sack")!),
            PlayerInTeamModel(getElement(allPlayers, withName: "Slaw")!),
            PlayerInTeamModel(getElement(allPlayers, withName: "Peter")!),
            PlayerInTeamModel(getElement(allPlayers, withName: "Paul")!)]
        
        return [
            // Oldham and Rochdale
            ClubModel(latitude : 53.657975, longitude : -2.182020, name : "Alpha Whitworth"),
            ClubModel(latitude : 53.582334, longitude : -2.217064, name : "Balderstone"),
            ClubModel(latitude : 53.536199, longitude : -2.218598, name : "Blackeley"),
            ClubModel(latitude : 53.551569, longitude : -2.003642, name : "Dons"),
            ClubModel(latitude : 53.613045, longitude : -2.338031, name : "Edenfield"),
            ClubModel(latitude : 53.545502, longitude : -2.153651, name : "Kashmir"),
            ClubModel(latitude : 53.555113, longitude : -2.234392, name : "Lancashire Racquets"),
            ClubModel(latitude : 53.541569, longitude : -2.003642, name : "Lydgate"),
            ClubModel(latitude : 53.460082, longitude : -2.193403, name : "Manchester Unity"),
            ClubModel(latitude : 53.618584, longitude : -2.149437, name : "Roch Bridge"),
            ClubModel(latitude : 53.531560, longitude : -2.003642, name : "Saddleworth"),
            ClubModel(latitude : 53.625794, longitude : -2.168755, name : "Shawclough"),
            ClubModel(latitude : 53.601250, longitude : -2.188561, name : "Spotland"),
            ClubModel(latitude : 53.608820, longitude : -2.104723, name : "Tara Hollingworth"),
            ClubModel(latitude : 53.502596, longitude : -2.217264, name : "MMCBC"),
            // Manchester
            ClubModel(latitude : 53.376532, longitude : -2.351253, name : "Blue Triangle"),
            ClubModel(latitude : 53.360062, longitude : -2.198274, name : "Carrington"),
            ClubModel(latitude : 53.384926, longitude : -2.183859, name : "Cheadle Hulme"),
            ClubModel(latitude : 53.361480, longitude : -2.048397, name : "Disley"),
            ClubModel(latitude : 53.445897, longitude : -2.248568, name : "Dome"),
            ClubModel(latitude : 53.367823, longitude : -2.158017, name : "Edgeley"),
            ClubModel(latitude : 53.419537, longitude : -2.339000, name : "Forest"),
            ClubModel(latitude : 53.457945, longitude : -2.234832, name : "Shire", teams : [TeamInClubModel("Shire1", players : teamShire1Players), TeamInClubModel("Shire2"), TeamInClubModel("Shire3")], players:clubShirePlayers),
            ClubModel(latitude : 53.561111, longitude : -2.272721, name : "Heys", teams : [TeamInClubModel("Heys-A"), TeamInClubModel("Heys-B" , players:teamHeysBPlayers), TeamInClubModel("Heys-C")], players: clubHeysPlayers),
            ClubModel(latitude : 53.485997, longitude : -2.140424, name : "Medlock"),
            ClubModel(latitude : 53.468822, longitude : -2.365570, name : "Nomad"),
            ClubModel(latitude : 53.419537, longitude : -2.338984, name : "PVBC"),
            ClubModel(latitude : 53.469550, longitude : -2.071247, name : "Ralley"),
            ClubModel(latitude : 53.419559, longitude : -2.339005, name : "Silver Feather"),
            ClubModel(latitude : 53.582332, longitude : -2.217037, name : "Yeti"),
            // Whitefield
            ClubModel(latitude : 53.582926, longitude : -2.307591, name : "Bury"),
            ClubModel(latitude : 53.579150, longitude : -2.537962, name : "Forrest"),
            ClubModel(latitude : 53.487137, longitude : -2.334725, name : "GMT"),
            ClubModel(latitude : 53.561111, longitude : -2.272721, name : "Heys"),
            ClubModel(latitude : 53.555113, longitude : -2.234392, name : "Lancashire Racquets"),
            ClubModel(latitude : 53.583014, longitude : -2.480808, name : "Markland Hill")
        ]
    }
    func getAllLeagues() -> [LeagueModel] {
        return [
            LeagueModel("Oldham & Rochdale Badminton League", image: nil, divisions : 3,
                clubs : [
                    ClubInLeagueModel(getElement(allClubs, withName:"Alpha Whitworth")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Balderstone")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Blackeley")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Dons")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Edenfield")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Kashmir")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Lancashire Racquets")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Lydgate")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Manchester Unity")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Roch Bridge")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Saddleworth")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Shawclough")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Spotland")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Tara Hollingworth")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"MMCBC")!)
                ]
            ),
            LeagueModel("Someshire Badminton League", image: nil, divisions : 4,
                clubs : [
                    ClubInLeagueModel(getElement(allClubs, withName:"Blue Triangle")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Carrington")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Cheadle Hulme")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Disley")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Dome")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Edgeley")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Shire")!), // 6
                    ClubInLeagueModel(getElement(allClubs, withName:"Heys")!), // 7
                    ClubInLeagueModel(getElement(allClubs, withName:"Medlock")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Nomad")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Ralley")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Silver Feather")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Yeti")!)
                ]
            ),
            LeagueModel("Whitefield and District  Badminton League", image: nil, divisions : 3,
                clubs : [
                    ClubInLeagueModel(getElement(allClubs, withName:"Blackeley")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Bury")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Forrest")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"GMT")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Heys")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Lancashire Racquets")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Markland Hill")!)
                ]
            )
        ]
    }
    func clearScores() {
        for match in self.matchCard.matchEntries {
            for game in match.gameEntries {
                game.clear()
            }
        }
    }
    func clear() {
        self.matchCard.league = nil
        self.matchCard.division = 0
        self.matchCard.homeClub = nil
        self.clearScores()
        matchCard.homeTeamBag!.team = nil
        matchCard.homeTeamBag!.clearPlayerModels()
        matchCard.awayTeamBag.team = nil
        matchCard.awayTeamBag.clearPlayerModels()
    }
}