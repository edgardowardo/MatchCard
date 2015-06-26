//
//  DataManager.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 26/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation

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
            PlayerInMatchModel(PlayerModel(name: "A1", image: nil)),
            PlayerInMatchModel(PlayerModel(name: "A2", image: nil)),
            PlayerInMatchModel(PlayerModel(name: "B1", image: nil)),
            PlayerInMatchModel(PlayerModel(name: "B2", image: nil)),
            PlayerInMatchModel(PlayerModel(name: "C1", image: nil)),
            PlayerInMatchModel(PlayerModel(name: "C2", image: nil))
        ]
        matchCard.awayTeamBag = TeamInMatchModel()
        matchCard.awayTeamBag.team = TeamModel(isAddme: false, name: "MMCBC-C", image: nil)
        matchCard.awayTeamBag.isHome = false
        matchCard.awayTeamBag.players = [
            PlayerInMatchModel(PlayerModel(name: "D1", image: nil)),
            PlayerInMatchModel(PlayerModel(name: "D2", image: nil)),
            PlayerInMatchModel(PlayerModel(name: "E1", image: nil)),
            PlayerInMatchModel(PlayerModel(name: "E2", image: nil)),
            PlayerInMatchModel(PlayerModel(name: "F1", image: nil)),
            PlayerInMatchModel(PlayerModel(name: "F2", image: nil))
        ]
    }
}