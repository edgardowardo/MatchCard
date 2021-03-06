//
//  MatchCardCollectionViewLayout.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 07/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

/*
    Although the cells are layed out as simple as using the UICollectionViewFlowLayout instance, the team players supplementary view transforms out completely from the bottom footer view to a matrix column and row heading on the top and left margins of the containing collection view.
*/

class MatchCardStandardLayout : UICollectionViewLayout{
    //
    // MARK: Properties
    //
    var totalHeight = CGFloat(0)
    var layoutInfo = [String : AnyObject]()
    var suppsInfo = [String : UICollectionViewLayoutAttributes]()
    var alphaCells : CGFloat {
        get { return 1.0 }
    }
    var layout : LayoutType? {
        get {
            if (self.isKindOfClass(MatchEntryEditLayout)) {
                return .Edit
            } else if (self.isKindOfClass(MatchCardStandardLayout)) {
                return .Standard
            } else {
                assertionFailure("Unknown layout type")
                return nil
            }
        }
    }
    //
    // MARK: Helpers
    //
    func debugMe(fromMethod : String = "") {
        if (Common.printDebug()) {
            var awayPlayersAttrs = self.suppsInfo[MatchPlayersReusableView.constantAwayKind]
            println("awayPlayers.frame=\(awayPlayersAttrs!.frame); \(self.getLayoutString()).\(fromMethod)")
        }
    }
    func yOfPlayersView(_ proposedContentOffset: CGPoint? = nil) -> CGFloat {
        if (proposedContentOffset != nil) {
            return proposedContentOffset!.y + UIScreen.mainScreen().bounds.size.height - awayPlayersSize().height
        } else {
            let contentOffset = self.collectionView?.contentOffset
            let yPlayers = contentOffset!.y + UIScreen.mainScreen().bounds.size.height - awayPlayersSize().height
            return yPlayers
        }
    }
    func yOfHeadersView(_ proposedContentOffset: CGPoint? = nil) -> CGFloat {
        var yHeader = self.collectionView?.contentOffset.y
        if (proposedContentOffset != nil) {
            yHeader = proposedContentOffset!.y
        }
        // If pulled upwards pull it upwards. If pulled downwards, don't let it past the screen so it sticks on the CGPointZero
        if yHeader > CGFloat(0) {
            yHeader = CGFloat(0)
        }
        return yHeader!
    }
    func yOfScoreView(_ proposedContentOffset: CGPoint? = nil) -> CGFloat {
        var yScore = yOfHeadersView(proposedContentOffset) + headerSummarySize().height
        var yOffset = self.collectionView?.contentOffset.y
        if (proposedContentOffset != nil) {
            yOffset = proposedContentOffset?.y
        }
        // If pushed upwards, don't let it disappear from the screen!
        if (yOffset >= headerSummarySize().height
            && self.layout! != .Edit) {
            yScore = yOffset!
        }
        return yScore
    }
    func cellSize() -> CGSize {
        return MatchEntryCell.constantDefaultSize
    }
    func homePlayersSize() -> CGSize {
        return MatchPlayersReusableView.constantDefaultSize
    }
    func awayPlayersSize() -> CGSize {
        return MatchPlayersReusableView.constantDefaultSize
    }
    func headerSummarySize() -> CGSize {
        return MatchHeaderReusableView.constantDefaultSize
    }
    func scoreSize() -> CGSize {
        return ScoreHeaderReusableView.constantDefaultSize
    }
    func getLayoutString()->String {
        switch self.layout! {
        case .Edit :
            return "Edit"
        case .Standard :
            return "Standard"
        default :
            return "Unknown"
        }
    }
    //
    // MARK: Lifecycle; Transitioning Between Layouts
    //
    override func prepareForTransitionFromLayout(oldLayout: UICollectionViewLayout) {
        debugMe(fromMethod: "\(__FUNCTION__)")
    }
    override func prepareForTransitionToLayout(newLayout: UICollectionViewLayout!) {
        debugMe(fromMethod: "\(__FUNCTION__)")
    }
    override func finalizeLayoutTransition() {
        debugMe(fromMethod: "\(__FUNCTION__)")
    }
    //
    // MARK: Lifecycle; Collection View Updates
    //
    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        debugMe(fromMethod: "\(__FUNCTION__)")
    }
    override func finalizeCollectionViewUpdates() {
        debugMe(fromMethod: "\(__FUNCTION__)")
    }
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        var homePlayersAttrs = self.suppsInfo[MatchPlayersReusableView.constantHomeKind]
        homePlayersAttrs!.frame.origin.y = yOfPlayersView(proposedContentOffset)
        var awayPlayersAttrs = self.suppsInfo[MatchPlayersReusableView.constantAwayKind]
        awayPlayersAttrs!.frame.origin.y = yOfPlayersView(proposedContentOffset)
        var homeScoreAttrs = self.suppsInfo[ScoreHeaderReusableView.constantHomeKind]
        homeScoreAttrs!.frame.origin.y = yOfScoreView(proposedContentOffset)
        var awayScoreAttrs = self.suppsInfo[ScoreHeaderReusableView.constantAwayKind]
        awayScoreAttrs!.frame.origin.y = yOfScoreView(proposedContentOffset)
        return proposedContentOffset
    }
    
    override func prepareLayout() {
        let indexPaths : NSArray = self.collectionView!.indexPathsForSelectedItems()
        var indexPathSelected = NSIndexPath(forRow: -1, inSection: 0)
        if (indexPaths.count > 0) {
            indexPathSelected = indexPaths[0] as! NSIndexPath
        }
        let numSections = collectionView?.numberOfSections()
        var cellInfo = [NSIndexPath : AnyObject]()
        let cellKind = MatchEntryCell.constantReuseIdentifier
        let cellSize = self.cellSize()
        let cellOriginX = UIScreen.mainScreen().bounds.size.width / 2  - self.cellSize().width / 2
        let numItems = collectionView?.numberOfItemsInSection(0)
        self.totalHeight = self.prepareLayoutForHeaderViews()
        for var indexItem = 0; indexItem < numItems; indexItem++ {
            var indexPath = NSIndexPath(forRow: indexItem, inSection: 0)
            var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = CGRectMake(cellOriginX, CGFloat(totalHeight), cellSize.width, cellSize.height)
            if indexPathSelected.isEqual(indexPath) {
                attributes.alpha = 1.0
            } else {
                attributes.alpha = self.alphaCells
            }
            cellInfo[indexPath] = attributes
            totalHeight += cellSize.height
        }
        layoutInfo[cellKind] = cellInfo
        self.prepareLayoutForSupplementaryViews()
        debugMe(fromMethod: "\(__FUNCTION__)")
    }
    func prepareLayoutForHeaderViews() -> CGFloat {
        // Header Summary
        let headerKind = MatchHeaderReusableView.constantKind
        var headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: headerKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        headerAttributes.alpha = 1
        headerAttributes.frame = CGRectMake(0, yOfHeadersView(), headerSummarySize().width, headerSummarySize().height)
        headerAttributes.zIndex += 1
        self.suppsInfo[headerKind] = headerAttributes
        // Header Home Score
        let scoreHomeKind = ScoreHeaderReusableView.constantHomeKind
        var scoreHomeAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: scoreHomeKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        scoreHomeAttributes.alpha = 0.9
        scoreHomeAttributes.frame = CGRectMake(0, yOfScoreView(), scoreSize().width, scoreSize().height)
        scoreHomeAttributes.zIndex += 2
        self.suppsInfo[scoreHomeKind] = scoreHomeAttributes
        // Header Away Score
        let scoreAwayKind = ScoreHeaderReusableView.constantAwayKind
        var scoreAwayAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: scoreAwayKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        scoreAwayAttributes.alpha = 1
        scoreAwayAttributes.frame = CGRectMake(scoreSize().width, yOfScoreView(), scoreSize().width, scoreSize().height)
        scoreAwayAttributes.zIndex += 2
        self.suppsInfo[scoreAwayKind] = scoreAwayAttributes
        // Return the total height for content size computation
        return headerSummarySize().height + scoreSize().height
    }
    func prepareLayoutForSupplementaryViews() {
        // Home
        let homePlayersKind = MatchPlayersReusableView.constantHomeKind
        var homePlayersAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: homePlayersKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        homePlayersAttributes.alpha = 0.9
        homePlayersAttributes.frame = CGRectMake(0,
            yOfPlayersView(), homePlayersSize().width, homePlayersSize().height)
        homePlayersAttributes.zIndex += 1
        self.suppsInfo[homePlayersKind] = homePlayersAttributes
       // Away
        let awayPlayersKind = MatchPlayersReusableView.constantAwayKind
        var awayPlayersAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: awayPlayersKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        awayPlayersAttributes.alpha = 1
        awayPlayersAttributes.frame = CGRectMake(awayPlayersSize().width,
            yOfPlayersView(), awayPlayersSize().width, awayPlayersSize().height)
        awayPlayersAttributes.zIndex += 1
        self.suppsInfo[awayPlayersKind] = awayPlayersAttributes
    }
    override func collectionViewContentSize() -> CGSize {
        let count : Int? = collectionView?.numberOfItemsInSection(0)
        let numSections = collectionView?.numberOfSections()
        let cellSize = self.cellSize()
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.totalHeight + cellSize.height * CGFloat(2.5))
    }
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let cellKind = MatchEntryCell.constantReuseIdentifier
        var cellInfo = layoutInfo[cellKind] as! [NSIndexPath : AnyObject]
        return cellInfo[indexPath] as! UICollectionViewLayoutAttributes
    }
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return self.suppsInfo[elementKind]
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        let cellKind = MatchEntryCell.constantReuseIdentifier
        var cellInfo = [NSIndexPath : AnyObject]()
        cellInfo = layoutInfo[cellKind] as! [NSIndexPath : AnyObject]
        var elements = [UICollectionViewLayoutAttributes]()
        for (indexPath, attributes) in cellInfo {
            if CGRectIntersectsRect(rect, attributes.frame) {
                elements.append(attributes as! UICollectionViewLayoutAttributes)
            }
        }
        var headerAttrs = self.suppsInfo[MatchHeaderReusableView.constantKind]!
        if (CGRectIntersectsRect(rect, headerAttrs.frame)) {
            elements.append(headerAttrs)
        }
        elements.append(self.suppsInfo[MatchPlayersReusableView.constantHomeKind]!)
        elements.append(self.suppsInfo[MatchPlayersReusableView.constantAwayKind]!)
        elements.append(self.suppsInfo[ScoreHeaderReusableView.constantHomeKind]!)
        elements.append(self.suppsInfo[ScoreHeaderReusableView.constantAwayKind]!)
        return elements
    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}