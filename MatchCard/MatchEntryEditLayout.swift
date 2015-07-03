//
//  MatchEntryEditLayout.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 09/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class MatchEntryEditLayout : MatchCardStandardLayout {
    override func cellSize() -> CGSize {
        return MatchEntryCell.Collection.Edit.Cell.Size
    }
    override var alphaCells : CGFloat {
        get {
            return 0.1
        }
    }
    override func prepareLayoutForSupplementaryViews() {
        super.prepareLayoutForSupplementaryViews()
        var awayPlayersAttributes = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Away]!
        awayPlayersAttributes.frame.origin.x += awayPlayersAttributes.frame.size.width
        var homePlayersAttributes = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Home]!
        homePlayersAttributes.frame.origin.x -= homePlayersAttributes.frame.size.width
    }
    override func prepareLayoutForHeaderViews() -> CGFloat {
        var total = super.prepareLayoutForHeaderViews()
        var scoreHomeAttributes = self.suppsInfo[ScoreHeaderReusableView.Collection.Kind.Home]!
        scoreHomeAttributes.frame.origin.x -= scoreHomeAttributes.frame.size.width
        var scoreAwayAttributes = self.suppsInfo[ScoreHeaderReusableView.Collection.Kind.Away]!
        scoreAwayAttributes.frame.origin.x += scoreAwayAttributes.frame.size.width
        return total
    }
}