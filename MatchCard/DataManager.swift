//
//  DataManager.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 26/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import Parse

class DataManager {
    static let sharedInstance = DataManager()
    lazy var allLeagues = DataManager.sharedInstance.getAllLeagues()
    lazy var allClubs = DataManager.sharedInstance.getAllClubs()
    lazy var allPlayers = DataManager.sharedInstance.getAllPlayers()
    lazy var matchCard = DataManager.sharedInstance.getMatchCard()
    func getMatchCard() -> MatchCardModel {
        let l = allLeagues[1]
        let c = l.clubs![6] // GHAP
        let t = c.club?.teams![0] // GHAP2
        var matchCard = MatchCardModel()
        matchCard.league = l
        matchCard.division = 2
        matchCard.date = NSDate()
        matchCard.homeClub = c
        matchCard.homeTeamBag = TeamInMatchModel()
        matchCard.homeTeamBag!.team = t
        matchCard.homeTeamBag!.players = [
            PlayerInMatchModel("A1", getElement(allPlayers, withName: "Edgar")),
            PlayerInMatchModel("A2"), //, getElement(allPlayers, withName: "Slawomir")), //   ), //
            PlayerInMatchModel("B3"), //, getElement(allPlayers, withName: "Pete")),
            PlayerInMatchModel("B4"), //, getElement(allPlayers, withName: "Khai")),
            PlayerInMatchModel("C5"), //, getElement(allPlayers, withName: "Simon Sack")),
            PlayerInMatchModel("C6") //, getElement(allPlayers, withName: "Kristof"))
        ]
        matchCard.awayTeamBag = TeamInMatchModel()
        matchCard.awayTeamBag.team = l.clubs![7].club?.teams![1]  // Heys-B
        matchCard.awayTeamBag.players = [
            PlayerInMatchModel("A1"),
            PlayerInMatchModel("A2", getElement(allPlayers, withName: "Slaw")),
            PlayerInMatchModel("B3"),
            PlayerInMatchModel("B4"),
            PlayerInMatchModel("C5"),
            PlayerInMatchModel("C6")
        ]
        
        let homeTeam = matchCard.homeTeamBag!
        let awayTeam = matchCard.awayTeamBag
        
        matchCard.matchEntries = []
        matchCard.matchEntries.append(MatchEntryModel(01, homeScore: 10, awayScore: 21, homeNote: "1&3",  homeTeam.players![0], homeTeam.players![2], awayNote: "1&3", awayTeam.players![0], awayTeam.players![2]))
        matchCard.matchEntries.append(MatchEntryModel(02, homeScore: 14, awayScore: 21, homeNote: "2&5",  homeTeam.players![1], homeTeam.players![4], awayNote: "2&5", awayTeam.players![1], awayTeam.players![4]))
        matchCard.matchEntries.append(MatchEntryModel(03, homeScore: 18, awayScore: 21, homeNote: "4&6",  homeTeam.players![3], homeTeam.players![5], awayNote: "4&6", awayTeam.players![3], awayTeam.players![5]))
        matchCard.matchEntries.append(MatchEntryModel(04, homeScore: 19, awayScore: 21, homeNote: "3&5",  homeTeam.players![2], homeTeam.players![4], awayNote: "3&5", awayTeam.players![2], awayTeam.players![4]))
        matchCard.matchEntries.append(MatchEntryModel(05, homeScore: 21, awayScore: 19, homeNote: "1&4",  homeTeam.players![0], homeTeam.players![3], awayNote: "1&4", awayTeam.players![0], awayTeam.players![3]))
        matchCard.matchEntries.append(MatchEntryModel(06, homeScore: 21, awayScore: 18, homeNote: "2&6",  homeTeam.players![1], homeTeam.players![5], awayNote: "2&6", awayTeam.players![1], awayTeam.players![5]))
        matchCard.matchEntries.append(MatchEntryModel(07, homeScore: 16, awayScore: 21, homeNote: "B",  homeTeam.players![2], homeTeam.players![3], awayNote: "A", awayTeam.players![0], awayTeam.players![1]))
        matchCard.matchEntries.append(MatchEntryModel(08, homeScore: 18, awayScore: 21, homeNote: "A",  homeTeam.players![0], homeTeam.players![1], awayNote: "C", awayTeam.players![4], awayTeam.players![5]))
        matchCard.matchEntries.append(MatchEntryModel(09, homeScore: 16, awayScore: 21, homeNote: "C",  homeTeam.players![4], homeTeam.players![5], awayNote: "B", awayTeam.players![3], awayTeam.players![4]))
        matchCard.matchEntries.append(MatchEntryModel(10, homeScore: 09, awayScore: 21, homeNote: "B",  homeTeam.players![2], homeTeam.players![3], awayNote: "C", awayTeam.players![4], awayTeam.players![5]))
        matchCard.matchEntries.append(MatchEntryModel(11, homeScore: 06, awayScore: 21, homeNote: "C",  homeTeam.players![4], homeTeam.players![5], awayNote: "A", awayTeam.players![0], awayTeam.players![1]))
        matchCard.matchEntries.append(MatchEntryModel(12, homeScore: 19, awayScore: 21, homeNote: "A",  homeTeam.players![0], homeTeam.players![1], awayNote: "B", awayTeam.players![2], awayTeam.players![3]))
        matchCard.matchEntries.append(MatchEntryModel(13, homeScore: 15, awayScore: 21, homeNote: "C",  homeTeam.players![4], homeTeam.players![5], awayNote: "C", awayTeam.players![4], awayTeam.players![5]))
        matchCard.matchEntries.append(MatchEntryModel(14, homeScore: 02, awayScore: 21, homeNote: "C",  homeTeam.players![4], homeTeam.players![5], awayNote: "C", awayTeam.players![4], awayTeam.players![5]))
        matchCard.matchEntries.append(MatchEntryModel(15, homeScore: 04, awayScore: 21, homeNote: "B",  homeTeam.players![2], homeTeam.players![3], awayNote: "B", awayTeam.players![2], awayTeam.players![3]))
        matchCard.matchEntries.append(MatchEntryModel(16, homeScore: 19, awayScore: 21, homeNote: "B",  homeTeam.players![2], homeTeam.players![3], awayNote: "B", awayTeam.players![2], awayTeam.players![3]))
        matchCard.matchEntries.append(MatchEntryModel(17, homeScore: 16, awayScore: 21, homeNote: "A",  homeTeam.players![0], homeTeam.players![1], awayNote: "A", awayTeam.players![0], awayTeam.players![1]))
        matchCard.matchEntries.append(MatchEntryModel(18, homeScore: 15, awayScore: 21, homeNote: "A",  homeTeam.players![0], homeTeam.players![1], awayNote: "A", awayTeam.players![0], awayTeam.players![1]))

        return matchCard
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
        for i in 0 ..< 18 {
            self.matchCard.matchEntries[i].clear()
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