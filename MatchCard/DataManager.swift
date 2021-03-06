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
    var matchCard = MatchCardModel()
    var hasLeagueName : Bool {
        get {
            return matchCard.leagueName.isEmpty
        }
    }
    init() {
        matchCard.league = LeagueModel(isAddme: false, name: "Oldham & Rochdale Badminton League", image: nil)        
        matchCard.division = 1
        matchCard.date = NSDate()
        matchCard.location = "Blackley"
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
            PlayerInMatchModel("A1", PlayerModel(name: "unknown", image: UIImage(named: "A1"))),
            PlayerInMatchModel("A2", PlayerModel(name: "unknown", image: UIImage(named: "A2"))),
            PlayerInMatchModel("B1", PlayerModel(name: "unknown", image: UIImage(named: "B1"))),
            PlayerInMatchModel("B2", PlayerModel(name: "unknown", image: nil)),
            PlayerInMatchModel("C1", PlayerModel(name: "unknown", image: nil)),
            PlayerInMatchModel("C2", PlayerModel(name: "unknown", image: nil))
        ]
        matchCard.awayTeamBag = TeamInMatchModel()
        matchCard.awayTeamBag.team = TeamModel(isAddme: false, name: "MMCBC-C", image: nil)
        matchCard.awayTeamBag.isHome = false
        matchCard.awayTeamBag.players = [
            PlayerInMatchModel("D1", PlayerModel(name: "unknown", image: nil)),
            PlayerInMatchModel("D2", PlayerModel(name: "unknown", image: nil)),
            PlayerInMatchModel("E1", PlayerModel(name: "unknown", image: nil)),
            PlayerInMatchModel("E2", PlayerModel(name: "unknown", image: nil)),
            PlayerInMatchModel("F1", PlayerModel(name: "unknown", image: nil)),
            PlayerInMatchModel("F2", PlayerModel(name: "unknown", image: nil))
        ]
    }
}