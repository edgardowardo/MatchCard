//
//  MatchPlayersLayout.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 17/07/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class AwayPlayersLayout : MatchCardStandardLayout {
    override var alphaCells : CGFloat {
        get {
            return 0.1
        }
    }
    override func prepareLayoutForSupplementaryViews() {
        super.prepareLayoutForSupplementaryViews()
        var yOffset : CGFloat? = self.collectionView?.contentOffset.y
        var awayPlayersAttributes = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Away]!
        awayPlayersAttributes.alpha = 1
        awayPlayersAttributes.frame = CGRectMake(0, yOffset!, MatchPlayersReusableView.Collection.Cell.Assignment.Width, MatchPlayersReusableView.Collection.Cell.Assignment.Height - UIToolbar.Size.Height)
    }
    override func targetContentOffsetForProposedContentOffsetWrappedFunction(proposedContentOffset : CGPoint) -> CGPoint {
        var newContentOffset = super.targetContentOffsetForProposedContentOffsetWrappedFunction(proposedContentOffset)
        var yOffset : CGFloat? = self.collectionView?.contentOffset.y
        var awayPlayersAttrs = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Away]
        awayPlayersAttrs!.frame.origin.y = yOffset!
        return newContentOffset
    }
}