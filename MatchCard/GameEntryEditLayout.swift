//
//  GameEntryEditLayout.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 09/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class GameEntryEditLayout : MatchCardStandardLayout {
    override func cellSize() -> CGSize {
        return GameEntryCell.Collection.Edit.Cell.Size
    }
    override var alphaCells : CGFloat {
        get {
            return 0.1
        }
    }
    override func setAlphaTo(homeNotes : UICollectionViewLayoutAttributes, andAwayNotes awayNotes : UICollectionViewLayoutAttributes, whenSelected : Bool, atIndexPath indexPath : NSIndexPath) {
        super.setAlphaTo(homeNotes, andAwayNotes: awayNotes, whenSelected: whenSelected, atIndexPath: indexPath)
        if whenSelected {
            homeNotes.alpha = 1.0
            awayNotes.alpha = 1.0
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