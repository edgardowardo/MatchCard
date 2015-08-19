//
//  MatchPlayersStandardLayout.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 16/07/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class MatchPlayersStandardLayout : UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .Horizontal
        itemSize = PlayerViewCell.Collection.Size

        // Calculate minimum line spacing depending on screen size
        let containerWidth = MatchPlayersReusableView.Collection.Cell.Width
        let width2Players = PlayerViewCell.Collection.Size.width * 2
        minimumLineSpacing = CGFloat( (containerWidth - width2Players) / 2 )
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var newContentOffset = proposedContentOffset
        let divider = PlayerViewCell.Collection.Size.width + minimumLineSpacing
        let modulus = proposedContentOffset.x % divider
        let division = proposedContentOffset.x / divider
        if modulus < divider / 2 {
            newContentOffset.x = floor(division) * divider
        } else {
            newContentOffset.x = ceil(division) * divider
        }
        return newContentOffset
    }
}

class PlayersEditLayout: MatchPlayersStandardLayout {
    override init() {
        super.init()
        scrollDirection = .Vertical
        minimumLineSpacing = CGFloat(10)
        sectionInset = UIEdgeInsetsMake(25, 50, 0, 50)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class HomePlayersMatrixLayout : MatchPlayersStandardLayout {
    override init() {
        super.init()
        scrollDirection = .Vertical
        minimumLineSpacing = CGFloat(50) // TODO: calculate depending on screen size! and adjusted with the text result of a match entry result
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class AwayPlayersMatrixLayout : MatchPlayersStandardLayout {
    override init() {
        super.init()
        // Calculate minimum line spacing depending on screen size
        let containerWidth = UIScreen.mainScreen().bounds.size.width
        let width4Players = PlayerViewCell.Collection.Size.width * 4
        minimumLineSpacing = CGFloat( (containerWidth - width4Players) / 4 )
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

