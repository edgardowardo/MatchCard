//
//  DataManager.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 26/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    static let sharedInstance = DataManager()
    lazy var leagues = DataManager.sharedInstance.getLeagues()
    lazy var clubs = DataManager.sharedInstance.getClubs()
    var matchCard = MatchCardModel()
    init() {
        matchCard.league = self.getLeagues()[0]
        matchCard.division = 1
        matchCard.date = NSDate()
        matchCard.homeClub = self.getClubs()[0]
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
        matchCard.homeTeamBag.team = TeamModel(isAddme: false, name: "Blackeley", image: nil)
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
        matchCard.awayTeamBag.team = TeamModel(isAddme: false, name: "MMCBC-C", image: nil)
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
    func getClubs() -> [ClubModel] {
        return [
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
            ClubModel(latitude : 53.502596, longitude : -2.217264, name : "MMCBC")
        ]
    }
    func getLeagues() -> [LeagueModel] {
        return [LeagueModel("Oldham & Rochdale Badminton League", image: nil, divisions : 5),
            LeagueModel("Manchester Badminton League", image: nil, divisions : 4),
            LeagueModel("North Manchester Badminton League", image: nil, divisions : 3),
            LeagueModel("South Manchester Badminton League", image: nil, divisions : 2)]
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