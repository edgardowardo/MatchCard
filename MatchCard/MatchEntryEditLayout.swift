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
        let awayPlayersKind = MatchPlayersReusableView.constantAwayKind
        var awayPlayersAttributes = layoutInfo[awayPlayersKind] as! UICollectionViewLayoutAttributes
        awayPlayersAttributes.frame.origin.x += awayPlayersAttributes.frame.size.width
        let homePlayersKind = MatchPlayersReusableView.constantHomeKind
        var homePlayersAttributes = layoutInfo[homePlayersKind] as! UICollectionViewLayoutAttributes
        homePlayersAttributes.frame.origin.x -= homePlayersAttributes.frame.size.width
    }
    override func prepareLayoutForHeaderViews() -> CGFloat {
        var total = super.prepareLayoutForHeaderViews()
        // Header Home Score
        let scoreHomeKind = ScoreHeaderReusableView.constantHomeKind
        var scoreHomeAttributes = layoutInfo[scoreHomeKind] as! UICollectionViewLayoutAttributes
        scoreHomeAttributes.frame.origin.x -= scoreHomeAttributes.frame.size.width
        // Header Away Score
        let scoreAwayKind = ScoreHeaderReusableView.constantAwayKind
        var scoreAwayAttributes = layoutInfo[scoreAwayKind] as! UICollectionViewLayoutAttributes
        scoreAwayAttributes.frame.origin.x += scoreAwayAttributes.frame.size.width

        return total
    }
}