//
//  HomePlayersLayout.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 18/07/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class HomePlayersLayout : MatchCardStandardLayout {
    override var alphaCells : CGFloat {
        get {
            return 0.1
        }
    }
    override func prepareLayoutForSupplementaryViews() {
        super.prepareLayoutForSupplementaryViews()
        var yOffset : CGFloat? = self.collectionView?.contentOffset.y
        var homePlayersAttributes = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Home]!
        homePlayersAttributes.alpha = 1
        homePlayersAttributes.frame = CGRectMake(0, yOffset!, MatchPlayersReusableView.Collection.Cell.Assignment.Width, MatchPlayersReusableView.Collection.Cell.Assignment.Height - UIToolbar.Size.Height)
    }
    override func targetContentOffsetForProposedContentOffsetWrappedFunction(proposedContentOffset : CGPoint) -> CGPoint {
        var newContentOffset = super.targetContentOffsetForProposedContentOffsetWrappedFunction(proposedContentOffset)
        var yOffset : CGFloat? = self.collectionView?.contentOffset.y
        var homePlayersAttrs = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Home]
        homePlayersAttrs!.frame.origin.y = yOffset!
        return newContentOffset
    }
}