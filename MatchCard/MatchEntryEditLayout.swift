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
        return MatchEntryCell.constantEditingSize
    }
    override var alphaCells : CGFloat {
        get {
            return 0.1
        }
    }
    override func prepareLayoutForSupplementaryViews() {
        super.prepareLayoutForSupplementaryViews()
        var awayPlayersAttributes = self.suppsInfo[MatchPlayersReusableView.constantAwayKind]!
        awayPlayersAttributes.frame.origin.x += awayPlayersAttributes.frame.size.width
        var homePlayersAttributes = self.suppsInfo[MatchPlayersReusableView.constantHomeKind]!
        homePlayersAttributes.frame.origin.x -= homePlayersAttributes.frame.size.width
    }
    override func prepareLayoutForHeaderViews() -> CGFloat {
        var total = super.prepareLayoutForHeaderViews()
        var scoreHomeAttributes = self.suppsInfo[ScoreHeaderReusableView.constantHomeKind]!
        scoreHomeAttributes.frame.origin.x -= scoreHomeAttributes.frame.size.width
        var scoreAwayAttributes = self.suppsInfo[ScoreHeaderReusableView.constantAwayKind]!
        scoreAwayAttributes.frame.origin.x += scoreAwayAttributes.frame.size.width
        return total
    }
}