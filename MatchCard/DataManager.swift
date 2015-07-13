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
    var matchCard = MatchCardModel()
    init() {
        matchCard.league = nil // self.getLeagues()[0]
        matchCard.division = 1
        matchCard.date = NSDate()
        matchCard.homeClub = nil // self.getAllClubs()[0]
        matchCard.matchEntries = [
            MatchEntryModel(homeScore: 0, awayScore: 21),
            MatchEntryModel(homeScore: 1, awayScore: 21),
            MatchEntryModel(homeScore: 2, awayScore: 21),
            MatchEntryModel(homeScore: 3, awayScore: 21),
            MatchEntryModel(homeScore: 4, awayScore: 2),
            MatchEntryModel(homeScore: 5, awayScore: 3),
            MatchEntryModel(homeScore: 6, awayScore: 4),
            MatchEntryModel(homeScore: 7, awayScore: 21),
            MatchEntryModel(homeScore: 8, awayScore: 21),
            MatchEntryModel(homeScore: 9, awayScore: 21),
            MatchEntryModel(homeScore: 10, awayScore: 21),
            MatchEntryModel(homeScore: 11, awayScore: 9),
            MatchEntryModel(homeScore: 12, awayScore: 11),
            MatchEntryModel(homeScore: 13, awayScore: 10),
            MatchEntryModel(homeScore: 14, awayScore: 12),
            MatchEntryModel(homeScore: 15, awayScore: 21),
            MatchEntryModel(homeScore: 16, awayScore: 21),
            MatchEntryModel(homeScore: 17, awayScore: 21),
        ]        
        matchCard.homeTeamBag = TeamInMatchModel()
        matchCard.homeTeamBag.team = TeamInClubModel(isAddme: false, name: "MMCBC-1", image: nil)
        matchCard.homeTeamBag.isHome = true
        matchCard.homeTeamBag.players = [
            PlayerInMatchModel("A1", PlayerModel(name: "Edgar", image: UIImage(named: "A1"))),
            PlayerInMatchModel("A2", PlayerModel(name: "Slawomir", image: UIImage(named: "A2"))),
            PlayerInMatchModel("B1", PlayerModel(name: "Someguy", image: UIImage(named: "B1"))),
            PlayerInMatchModel("B2"),
            PlayerInMatchModel("C1"),
            PlayerInMatchModel("C2")
        ]
        matchCard.awayTeamBag = TeamInMatchModel()
        matchCard.awayTeamBag.team = TeamInClubModel(isAddme: false, name: "MMCBC-C", image: nil)
        matchCard.awayTeamBag.isHome = false
        matchCard.awayTeamBag.players = [
            PlayerInMatchModel("D1"),
            PlayerInMatchModel("D2"),
            PlayerInMatchModel("E1"),
            PlayerInMatchModel("E2"),
            PlayerInMatchModel("F1"),
            PlayerInMatchModel("F2")
        ]
    }
    func getClub(name : String) -> ClubModel? {
        let filteredArray = self.allClubs.filter() {
            if let type = ($0 as PFObject)["name"] as? String {
                return type.rangeOfString(name) != nil
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
            ClubModel(latitude : 53.457945, longitude : -2.234832, name : "GHAP"),
            ClubModel(latitude : 53.561111, longitude : -2.272721, name : "Heys"),
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
                    ClubInLeagueModel(getClub("Alpha Whitworth")!),
                    ClubInLeagueModel(getClub("Balderstone")!),
                    ClubInLeagueModel(getClub("Blackeley")!),
                    ClubInLeagueModel(getClub("Dons")!),
                    ClubInLeagueModel(getClub("Edenfield")!),
                    ClubInLeagueModel(getClub("Kashmir")!),
                    ClubInLeagueModel(getClub("Lancashire Racquets")!),
                    ClubInLeagueModel(getClub("Lydgate")!),
                    ClubInLeagueModel(getClub("Manchester Unity")!),
                    ClubInLeagueModel(getClub("Roch Bridge")!),
                    ClubInLeagueModel(getClub("Saddleworth")!),
                    ClubInLeagueModel(getClub("Shawclough")!),
                    ClubInLeagueModel(getClub("Spotland")!),
                    ClubInLeagueModel(getClub("Tara Hollingworth")!),
                    ClubInLeagueModel(getClub("MMCBC")!)
                ]
            ),
            LeagueModel("Manchester  Badminton League", image: nil, divisions : 4,
                clubs : [
                    ClubInLeagueModel(getClub("Blue Triangle")!),
                    ClubInLeagueModel(getClub("Carrington")!),
                    ClubInLeagueModel(getClub("Cheadle Hulme")!),
                    ClubInLeagueModel(getClub("Disley")!),
                    ClubInLeagueModel(getClub("Dome")!),
                    ClubInLeagueModel(getClub("Edgeley")!),
                    ClubInLeagueModel(getClub("GHAP")!),
                    ClubInLeagueModel(getClub("Heys")!),
                    ClubInLeagueModel(getClub("Medlock")!),
                    ClubInLeagueModel(getClub("Nomad")!),
                    ClubInLeagueModel(getClub("Ralley")!),
                    ClubInLeagueModel(getClub("Silver Feather")!),
                    ClubInLeagueModel(getClub("Yeti")!)
                ]
            ),
            LeagueModel("Whitefield and District  Badminton League", image: nil, divisions : 3,
                clubs : [
                    ClubInLeagueModel(getClub("Blackeley")!),
                    ClubInLeagueModel(getClub("Bury")!),
                    ClubInLeagueModel(getClub("Forrest")!),
                    ClubInLeagueModel(getClub("GMT")!),
                    ClubInLeagueModel(getClub("Heys")!),
                    ClubInLeagueModel(getClub("Lancashire Racquets")!),
                    ClubInLeagueModel(getClub("Markland Hill")!)
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
        matchCard.homeTeamBag.team = nil
        matchCard.homeTeamBag.players = [
            PlayerInMatchModel("A1"),
            PlayerInMatchModel("A2"),
            PlayerInMatchModel("B1"),
            PlayerInMatchModel("B2"),
            PlayerInMatchModel("C1"),
            PlayerInMatchModel("C2")
        ]
        matchCard.awayTeamBag.team = nil
        matchCard.awayTeamBag.players = [
            PlayerInMatchModel("D1"),
            PlayerInMatchModel("D2"),
            PlayerInMatchModel("E1"),
            PlayerInMatchModel("E2"),
            PlayerInMatchModel("F1"),
            PlayerInMatchModel("F2")
        ]
    }
}