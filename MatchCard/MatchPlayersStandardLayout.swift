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