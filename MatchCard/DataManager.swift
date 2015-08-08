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
    lazy var matchCard = DataManager.sharedInstance.newMatchCard_Open()
    
    func newMatchCard_3Discipline() -> MatchCardModel {
        return MatchCardModel()
    }
    
    func newMatchCard_RoundRobin() -> MatchCardModel {
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
        
        // Create the matrix
        for var i = 0; i < homeTeam.players!.count / 2; i++ {
            var homeNote =  getNote(i)
            let homePlayer1 = homeTeam.players![i].player
            let homePlayer2 = homeTeam.players![i+1].player
            for var j = 0; j < awayTeam.players!.count / 2; j++ {
                var awayNote =  getNote(j)
                let awayPlayer1 = awayTeam.players![j].player
                let awayPlayer2 = awayTeam.players![j+1].player
  
                

                
                

                
                //MatchEntryModel(01, homeScore: 0, awayScore: 0, homeNote: "1&3",  homePlayer1, homePlayer2, awayNote: "1&3", awayPlayer1, awayPlayer2)
                
                
//                var matchEntry : MatchEntryModel(0, homeNote, homePlayer1, homePlayer2, awayNote, awayPlayer1, awayPlayer2)
//                matchEntry.gameEntries = []
                
                
                
                
//                mc.matchEntries.append(matchEntry)
            }
        }
        return mc
    }
    
    func loadMatchCard_Open(mc : MatchCardModel) {
        if mc.cardType == .Open {
            let l = allLeagues[1]       // Manchester Badminton League
            let c = l.clubs![6]         // GHAP
            let t = c.club?.teams![0]   // GHAP2
            mc.division = 2
            mc.league = l
            mc.homeClub = c
            mc.homeTeamBag!.team = t
            mc.awayTeamBag.team = l.clubs![7].club?.teams![1]  // Heys-B
            (mc.homeTeamBag!.players![0] as PlayerInMatchModel).player = getElement(allPlayers, withName: "Edgar")
            (mc.awayTeamBag.players![1] as PlayerInMatchModel).player = getElement(allPlayers, withName: "Slaw")
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
            assertionFailure("unknown card type")
        }
    }
    
    func newMatchCard_Open() -> MatchCardModel {
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
        
        let matchEntry = MatchEntryModel(0)
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
            PlayerModel(name: "Mark Zuckerberg", image: UIImage(named: "markZ"))
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
        let teamGhap1Players = [PlayerInTeamModel(getElement(allPlayers, withName: "Khai")!),
            PlayerInTeamModel(getElement(allPlayers, withName: "Pete")!),
            PlayerInTeamModel(getElement(allPlayers, withName: "Someguy")!)]
        let clubGhapPlayers = [PlayerInClubModel(getElement(allPlayers, withName: "Slawomir")!), PlayerInClubModel(getElement(allPlayers, withName: "Kristof")!)]
        let clubHeysPlayers = [PlayerInClubModel(getElement(allPlayers, withName: "Mark Zuckerberg")!), PlayerInClubModel(getElement(allPlayers, withName: "Liza Doolittle")!)]
        let clubHeysBPlayers = [PlayerInTeamModel(getElement(allPlayers, withName: "Simon Sack")!)]
        
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
            ClubModel(latitude : 53.457945, longitude : -2.234832, name : "GHAP", teams : [TeamInClubModel("GHAP1", players : teamGhap1Players), TeamInClubModel("GHAP2"), TeamInClubModel("GHAP3")], players:clubGhapPlayers),
            ClubModel(latitude : 53.561111, longitude : -2.272721, name : "Heys", teams : [TeamInClubModel("Heys-A"), TeamInClubModel("Heys-B" , players:clubHeysBPlayers), TeamInClubModel("Heys-C")], players: clubHeysPlayers),
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
            LeagueModel("Manchester Badminton League", image: nil, divisions : 4,
                clubs : [
                    ClubInLeagueModel(getElement(allClubs, withName:"Blue Triangle")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Carrington")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Cheadle Hulme")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Disley")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Dome")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"Edgeley")!),
                    ClubInLeagueModel(getElement(allClubs, withName:"GHAP")!), // 6
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