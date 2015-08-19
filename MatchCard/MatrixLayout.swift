//
//  MatrixLayout.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 12/08/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class MatrixLayout : MatchCardStandardLayout {
    
    override func setAlphaTo(homeNotes : UICollectionViewLayoutAttributes, andAwayNotes awayNotes : UICollectionViewLayoutAttributes, whenSelected : Bool, atIndexPath indexPath : NSIndexPath) {
        super.setAlphaTo(homeNotes, andAwayNotes: awayNotes, whenSelected: whenSelected, atIndexPath: indexPath)
        homeNotes.alpha = 0
        awayNotes.alpha = 0
    }
    
    override func homePlayersSize() -> CGSize {
        return MatchPlayersReusableView.Collection.Matrix.Cell.Home.Size
    }
    
    override func awayPlayersSize() -> CGSize {
        return MatchPlayersReusableView.Collection.Matrix.Cell.Away.Size
    }
    
    override func prepareLayoutForHeaderViews() -> CGFloat {
        var someTotalHeight = super.prepareLayoutForHeaderViews()
        super.prepareLayoutForFooterViews()
        
        // Corner
        var cornerAttributes = self.suppsInfo[MatrixCornerReusableView.Collection.Kind]!
        cornerAttributes.alpha = CGFloat(1)
        cornerAttributes.frame = CGRectMake(0, yOfAwayPlayersView(), cornerSize().width, cornerSize().height)
        
        // Change away players
        var awayPlayersAttrs = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Away]!
        let xOfAway = homePlayersSize().width 
        awayPlayersAttrs.frame = CGRectMake(xOfAway, yOfAwayPlayersView(), awayPlayersSize().width, awayPlayersSize().height)
        
        // Change home players
        var homePlayersAttrs = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Home]!
        homePlayersAttrs.frame = CGRectMake(0, yOfHomePlayersView(), homePlayersSize().width, homePlayersSize().height)
        
        // don't add home because it's a vertical view running along item cells
        return someTotalHeight + awayPlayersSize().height
    }
        
    override func yOfHomePlayersView(_ proposedContentOffset: CGPoint? = nil) -> CGFloat {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        return headerSummarySize().height + scoreSize().height - statusBarHeight + awayPlayersSize().height
    }
    
    override func yOfAwayPlayersView(_ proposedContentOffset: CGPoint? = nil) -> CGFloat {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        var y = yOfScoreView(proposedContentOffset) + scoreSize().height
        var yOffset = self.collectionView?.contentOffset.y
        if (proposedContentOffset != nil) {
            yOffset = proposedContentOffset?.y
        }
        // If pushed upwards, don't let it disappear from the screen nor past the score headers
        if (yOffset >= headerSummarySize().height + scoreSize().height
            && self.layout != .Edit ) {
            y = yOffset! + statusBarHeight + scoreSize().height
        }
        return y
    }
    
    override func prepareLayoutForFooterViews() {
        // don't call super which calls this later in the preparation. we want to call it in prepare header!
        // super.prepareLayoutForFooterViews()
        var separatorAttrs = self.suppsInfo[MatchCardViewController.Separator.Kind]!
        var totalAttrs = self.suppsInfo[GameTotalsReusableView.Collection.Kind]!
        separatorAttrs.alpha = 0
        totalAttrs.alpha = 0
    }

    override func didPrepareLayoutForFooterViews() {
    }
    
    override func didPrepareSection(section: Int) {
        if (section + 1) % 3 == 0 {
            self.totalHeight += cellSize().height * 3
        }
    }
    
    override func didSetCellAttributes(attrs: UICollectionViewLayoutAttributes, withIndexPath indexPath: NSIndexPath) {
        let widthQuarter = UIScreen.mainScreen().bounds.size.width / 4
        let xFactor = CGFloat( (indexPath.section) % 3 )
        let xAdjustment = widthQuarter * 2
        let xOfQuarter = xAdjustment + xFactor * widthQuarter
        let xCenterOfQuarter = xOfQuarter - widthQuarter / 2
        let x = xCenterOfQuarter - cellSize().width / 2
        let y = self.totalHeight + CGFloat(indexPath.row) * cellSize().height
        var newRect = CGRectMake(x , y , cellSize().width, cellSize().height)
        attrs.frame = newRect
    }
    
}

