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
        let yHomeAdjustment = GameEntryCell.Collection.Default.Cell.Height * 4
        homePlayersAttrs.frame = CGRectMake(0, yOfHomePlayersView() - yHomeAdjustment, homePlayersSize().width, homePlayersSize().height)
        
        // don't add home because it's a vertical view running along item cells
        return someTotalHeight + awayPlayersSize().height
    }
        
    override func yOfHomePlayersView(_ proposedContentOffset: CGPoint? = nil) -> CGFloat {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        return headerSummarySize().height + scoreSize().height - statusBarHeight + awayPlayersSize().height
    }
    
    override func targetContentOffsetAdjustment(proposedContentOffset: CGPoint) -> CGPoint {
        var newContentOffset = super.targetContentOffsetAdjustment(proposedContentOffset)
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let upperLimit = headerSummarySize().height + scoreSize().height  - (statusBarHeight * 2)
        let midLimit = upperLimit - (scoreSize().height / 2)
        let lowLimit = headerSummarySize().height - (statusBarHeight * 2)
        if (newContentOffset.y >= midLimit && newContentOffset.y < upperLimit) {
            newContentOffset.y = upperLimit
        } else if (newContentOffset.y >= lowLimit && newContentOffset.y < midLimit) {
            newContentOffset.y = lowLimit
        }
        return newContentOffset
    }
    
    override func yOfAwayPlayersView(_ proposedContentOffset: CGPoint? = nil) -> CGFloat {
        var offset = self.collectionView?.contentOffset
        if (proposedContentOffset != nil) {
            offset = proposedContentOffset!
        }
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let upperLimit = headerSummarySize().height + scoreSize().height  - (statusBarHeight * 2)
        var y = headerSummarySize().height + scoreSize().height  - statusBarHeight
        if offset!.y >= upperLimit  { // prevent from being pushed out of the status bar
            y = offset!.y + statusBarHeight
        } else if offset!.y < 0 { // prevent from being pulled away from score headers
            y = yOfScoreView(offset) + scoreSize().height
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
    
    override func didPrepareSection(section: Int, withSectionAttributes sectionAttrs : UICollectionViewLayoutAttributes) {
        if (section + 1) % 3 == 0 {
            self.totalHeight += cellSize().height * 4
        }
        
        // calculate the correct X origin within the matrix.
        let widthQuarter = UIScreen.mainScreen().bounds.size.width / 4
        let xFactor = CGFloat( (section) % 3 )
        let xAdjustment = widthQuarter
        let x = xAdjustment + xFactor * widthQuarter
        sectionAttrs.frame.origin.x = x
        sectionAttrs.alpha = 1
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
    override func collectionViewContentSize() -> CGSize {
        let count : Int? = collectionView?.numberOfItemsInSection(0)
        let numSections = collectionView?.numberOfSections()
        let cellSize = self.cellSize()
        
        // allow auto scrolling upon matrix layout. problem is in iPhone6 and + there's too much space...
        var heightAdjustment = headerSummarySize().height +  scoreSize().height - 20
        let threshold = totalHeight - heightAdjustment
        if UIScreen.mainScreen().bounds.size.height < threshold {
            heightAdjustment = 0
        }
        
        let size = CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.totalHeight + heightAdjustment)
        return size
    }
}

