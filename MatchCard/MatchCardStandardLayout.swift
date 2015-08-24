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
            if (self.isKindOfClass(GameEntryEditLayout)) {
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
            var awayPlayersAttrs = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Away]
            println("awayPlayers.frame=\(awayPlayersAttrs!.frame); \(self.getLayoutString()).\(fromMethod)")
        }
    }
    func yOfHomePlayersView(_ proposedContentOffset: CGPoint? = nil) -> CGFloat {
        return yOfPlayersView(proposedContentOffset)
    }
    func yOfAwayPlayersView(_ proposedContentOffset: CGPoint? = nil) -> CGFloat {
        return yOfPlayersView(proposedContentOffset)
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
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        // NB. when pushed upwards the contentOffset.y gains positive. otherwise when pulled down, it becomes negative
        
        // When pulled down, the Y should be content offset which is the iPhone's frame
        var yHeader = self.collectionView?.contentOffset.y
        // proposed content offset is overridden during animation and must supercede the former (above)
        if (proposedContentOffset != nil) {
            yHeader = proposedContentOffset!.y
        }

        let threshold = (headerSummarySize().height - statusBarHeight*2 )
        let upperLimit = -(statusBarHeight) // this is +20
        // Pushed upwards, hence offset becomes positive
        if yHeader >= threshold {
            yHeader = yHeader! - (headerSummarySize().height - statusBarHeight)
        } else if yHeader >= upperLimit {
            yHeader = -(statusBarHeight)
        }
        return yHeader!
    }
    func yOfScoreView(_ proposedContentOffset: CGPoint? = nil) -> CGFloat {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        var yScore = yOfHeadersView(proposedContentOffset) + headerSummarySize().height
        var yOffset = self.collectionView?.contentOffset.y
        if (proposedContentOffset != nil) {
            yOffset = proposedContentOffset?.y
        }
        // If pushed upwards, don't let it disappear from the screen!
        if (yOffset >= headerSummarySize().height
            && self.layout! != .Edit) {
            yScore = yOffset! + statusBarHeight
        }
        return yScore
    }
    func cellSize() -> CGSize {
        return GameEntryCell.Collection.Default.Cell.Size
    }
    func cornerSize() -> CGSize {
        return MatrixCornerReusableView.Collection.Cell.Size
    }
    func homePlayersSize() -> CGSize {
        return MatchPlayersReusableView.Collection.Cell.Size
    }
    func awayPlayersSize() -> CGSize {
        return MatchPlayersReusableView.Collection.Cell.Size
    }
    func headerSummarySize() -> CGSize {
        return MatchHeaderReusableView.Collection.Cell.Size
    }
    func scoreSize() -> CGSize {
        return ScoreHeaderReusableView.Collection.Cell.Size
    }
    func matchEntrySize() -> CGSize {
        return MatchEntryWinnerReusableView.Collection.Cell.Size
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
    func targetContentOffsetForProposedContentOffsetWrappedFunction(proposedContentOffset : CGPoint) -> CGPoint {
        
        let newContentOffset = self.targetContentOffsetAdjustment(proposedContentOffset)
        
        var headerAttrs = self.suppsInfo[MatchHeaderReusableView.Collection.Kind]
        headerAttrs?.frame.origin.y = yOfHeadersView(newContentOffset)

        var cornerAttrs = self.suppsInfo[MatrixCornerReusableView.Collection.Kind]
        cornerAttrs?.frame.origin.y = yOfAwayPlayersView(newContentOffset)
        var homePlayersAttrs = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Home]
        homePlayersAttrs!.frame.origin.y = yOfHomePlayersView(newContentOffset)
        var awayPlayersAttrs = self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Away]
        awayPlayersAttrs!.frame.origin.y = yOfAwayPlayersView(newContentOffset)

        var homeScoreAttrs = self.suppsInfo[ScoreHeaderReusableView.Collection.Kind.Home]
        homeScoreAttrs!.frame.origin.y = yOfScoreView(newContentOffset)
        var awayScoreAttrs = self.suppsInfo[ScoreHeaderReusableView.Collection.Kind.Away]
        awayScoreAttrs!.frame.origin.y = yOfScoreView(newContentOffset)
        return newContentOffset
    }
    func targetContentOffsetAdjustment(proposedContentOffset: CGPoint) -> CGPoint {
        var newContentOffset = proposedContentOffset
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let threshold = (headerSummarySize().height - statusBarHeight*2 ) / 2
        ContainerViewController.isPannable = false
        if (proposedContentOffset.y < threshold) {
            newContentOffset.y = (-statusBarHeight)
            ContainerViewController.isPannable = true
        } else if proposedContentOffset.y >= threshold
            && proposedContentOffset.y <= (headerSummarySize().height - statusBarHeight*2 ) {
                newContentOffset.y = (headerSummarySize().height - statusBarHeight*2 )
        }        
        return newContentOffset
    }
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        return targetContentOffsetForProposedContentOffsetWrappedFunction(proposedContentOffset)
    }
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        return targetContentOffsetForProposedContentOffsetWrappedFunction(proposedContentOffset)
    }
    
    //
    // MARK: Layout preparation
    //
    override func prepareLayout() {
        let indexPaths : NSArray = self.collectionView!.indexPathsForSelectedItems()
        var indexPathSelected = NSIndexPath(forRow: -1, inSection: 0)
        if (indexPaths.count > 0) {
            indexPathSelected = indexPaths[0] as! NSIndexPath
        }
        let numSections = collectionView?.numberOfSections()
        
        var cellInfo = [NSIndexPath : AnyObject]()
        let cellKind = GameEntryCell.Collection.Kind
        let cellSize = self.cellSize()
        let cellOriginX = UIScreen.mainScreen().bounds.size.width / 2  - self.cellSize().width / 2
        
        let noteSize = EntryAnnotationReusableView.Collection.Cell.Size
        var noteHomeInfo = [NSIndexPath : AnyObject]()
        let noteHomeKind = EntryAnnotationReusableView.Collection.Home.Kind
        var noteAwayInfo = [NSIndexPath : AnyObject]()
        let noteAwayKind = EntryAnnotationReusableView.Collection.Away.Kind
        
        var matchInfo = [NSIndexPath : AnyObject]()
        let matchKind = MatchEntryWinnerReusableView.Collection.Kind

        self.totalHeight = self.prepareLayoutForHeaderViews()

        for var section = 0; section < numSections!; section++ {
            let numItems = collectionView?.numberOfItemsInSection(section)
            var firstAttribute : UICollectionViewLayoutAttributes?
            for var row = 0; row < numItems; row++ {
                var indexPath = NSIndexPath(forRow: row, inSection: section)
                
                // Home note
                var noteHomeAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: noteHomeKind, withIndexPath: indexPath)
                noteHomeAttributes.frame = CGRectMake(0, CGFloat(totalHeight), noteSize.width, noteSize.height)
                noteHomeAttributes.zIndex = 20
                noteHomeInfo[indexPath] = noteHomeAttributes
                
                // Away note
                var noteAwayAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: noteAwayKind, withIndexPath: indexPath)
                let noteAwayOriginX = UIScreen.mainScreen().bounds.size.width - noteSize.width
                noteAwayAttributes.frame = CGRectMake(noteAwayOriginX, CGFloat(totalHeight), noteSize.width, noteSize.height)
                noteAwayAttributes.zIndex = 20
                noteAwayInfo[indexPath] = noteAwayAttributes
                
                // Game Entry
                var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRectMake(cellOriginX, CGFloat(totalHeight), cellSize.width, cellSize.height)
                attributes.zIndex = 20
                
                if indexPathSelected.isEqual(indexPath) {
                    attributes.alpha = 1.0
                    setAlphaTo(noteHomeAttributes, andAwayNotes: noteAwayAttributes, whenSelected: true, atIndexPath: indexPath)
                } else {
                    attributes.alpha = self.alphaCells
                    setAlphaTo(noteHomeAttributes, andAwayNotes: noteAwayAttributes, whenSelected: false, atIndexPath: indexPath)
                }
                cellInfo[indexPath] = attributes
                
                self.didSetCellAttributes(attributes, withIndexPath: indexPath)
                
                // get the first attribute to be used by the match entry
                if row == 0 {
                    firstAttribute = attributes
                }
            }
            // Match Entry
            let indexPath = NSIndexPath(forRow: 0, inSection: section)
            var matchAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: matchKind, withIndexPath: indexPath)
            matchAttributes.frame = CGRectMake(firstAttribute!.frame.origin.x, firstAttribute!.frame.origin.y, matchEntrySize().width, matchEntrySize().height)
            matchAttributes.alpha = 0
            matchAttributes.zIndex = 10
            matchInfo[indexPath] = matchAttributes
            
            self.didPrepareSection(section, withSectionAttributes: matchAttributes)
        }
        layoutInfo[cellKind] = cellInfo
        layoutInfo[noteHomeKind] = noteHomeInfo
        layoutInfo[noteAwayKind] = noteAwayInfo
        layoutInfo[matchKind] = matchInfo
        self.willPrepareLayoutForFooterViews()
        self.prepareLayoutForFooterViews()
        self.didPrepareLayoutForFooterViews()
        debugMe(fromMethod: "\(__FUNCTION__)")
    }
    func didSetCellAttributes(attrs : UICollectionViewLayoutAttributes, withIndexPath indexPath : NSIndexPath) {
        self.totalHeight += cellSize().height
    }
    
    func didPrepareSection(section: Int, withSectionAttributes sectionAttrs : UICollectionViewLayoutAttributes) {
        // empty code to be overridden
    }
    func setAlphaTo(homeNotes : UICollectionViewLayoutAttributes, andAwayNotes awayNotes : UICollectionViewLayoutAttributes, whenSelected : Bool, atIndexPath indexPath : NSIndexPath) {
        if whenSelected {
            homeNotes.alpha = 1.0
            awayNotes.alpha = 1.0
            // on round robin, when setting to standard, set the non-section view to invisible. this is not the case on edit as we want to show the annotations. hence upon override in Edit mode, this condition will be set to alpha 1, regardless of the condition below!
            if DataManager.sharedInstance.matchCard.cardType!.isRepeatedNoteSuppressed() && indexPath.row > 0 {
                homeNotes.alpha = 0.0
                awayNotes.alpha = 0.0
            }
        } else {
            if DataManager.sharedInstance.matchCard.cardType!.isRepeatedNoteSuppressed() && indexPath.row > 0 {
                homeNotes.alpha = 0.0
                awayNotes.alpha = 0.0
            } else { // on open alpha is nearly invisible
                homeNotes.alpha = alphaCells
                awayNotes.alpha = alphaCells
            }
        }
    }
    func prepareLayoutForHeaderViews() -> CGFloat {
        // Header Summary
        let headerKind = MatchHeaderReusableView.Collection.Kind
        var headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: headerKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        headerAttributes.alpha = 1
        headerAttributes.frame = CGRectMake(0, yOfHeadersView(), headerSummarySize().width, headerSummarySize().height)
        headerAttributes.zIndex = 200
        self.suppsInfo[headerKind] = headerAttributes
        // Header Home Score
        let scoreHomeKind = ScoreHeaderReusableView.Collection.Kind.Home
        var scoreHomeAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: scoreHomeKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        scoreHomeAttributes.frame = CGRectMake(0, yOfScoreView(), scoreSize().width, scoreSize().height)
        scoreHomeAttributes.zIndex = 100
        self.suppsInfo[scoreHomeKind] = scoreHomeAttributes
        // Header Away Score
        let scoreAwayKind = ScoreHeaderReusableView.Collection.Kind.Away
        var scoreAwayAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: scoreAwayKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        scoreAwayAttributes.alpha = 1
        scoreAwayAttributes.frame = CGRectMake(scoreSize().width, yOfScoreView(), scoreSize().width, scoreSize().height)
        scoreAwayAttributes.zIndex = 100
        self.suppsInfo[scoreAwayKind] = scoreAwayAttributes

        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        // Return the total height for content size computation
        return headerSummarySize().height + scoreSize().height - statusBarHeight
    }
    func willPrepareLayoutForFooterViews() {
        // empty code to be overridden
    }
    func prepareLayoutForFooterViews() {
        // Corner
        let cornerKind = MatrixCornerReusableView.Collection.Kind
        var cornerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: cornerKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        cornerAttributes.frame = CGRectMake(homePlayersSize().width, yOfAwayPlayersView(), cornerSize().width, cornerSize().height)
        cornerAttributes.zIndex = 110
        cornerAttributes.alpha = 0
        self.suppsInfo[cornerKind] = cornerAttributes        
        
        // Home
        let homePlayersKind = MatchPlayersReusableView.Collection.Kind.Home
        var homePlayersAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: homePlayersKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        homePlayersAttributes.frame = CGRectMake(0, yOfHomePlayersView(), homePlayersSize().width, homePlayersSize().height)
        homePlayersAttributes.zIndex = 90
        self.suppsInfo[homePlayersKind] = homePlayersAttributes
        // Away
        let awayPlayersKind = MatchPlayersReusableView.Collection.Kind.Away
        var awayPlayersAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: awayPlayersKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        awayPlayersAttributes.alpha = 1
        awayPlayersAttributes.frame = CGRectMake(homePlayersSize().width, yOfAwayPlayersView(), awayPlayersSize().width, awayPlayersSize().height)
        awayPlayersAttributes.zIndex = 110
        self.suppsInfo[awayPlayersKind] = awayPlayersAttributes
        // Separator
        let separatorKind = MatchCardViewController.Separator.Kind
        var separatorAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: separatorKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        separatorAttributes.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width / 2, 0, 10, self.totalHeight)
        separatorAttributes.zIndex = 80
        
        self.suppsInfo[separatorKind] = separatorAttributes

        // Game Totals
        self.prepareLayoutForGameTotals()
    }
    func prepareLayoutForGameTotals() {
        let totalSize = GameTotalsReusableView.Collection.Cell.Size
        let totalKind = GameTotalsReusableView.Collection.Kind
        var totalAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: totalKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        totalAttributes.frame = CGRectMake(0, self.totalHeight, totalSize.width, totalSize.height)
        totalAttributes.zIndex = 20
        self.suppsInfo[totalKind] = totalAttributes
    }
    func didPrepareLayoutForFooterViews() {
        let gameTotalsSize = GameTotalsReusableView.Collection.Cell.Size
        self.totalHeight += gameTotalsSize.height
    }
    override func collectionViewContentSize() -> CGSize {
        let count : Int? = collectionView?.numberOfItemsInSection(0)
        let numSections = collectionView?.numberOfSections()
        let cellSize = self.cellSize()
        let size = CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.totalHeight + cellSize.height * CGFloat(2.5))
        return size
    }
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let cellKind = GameEntryCell.Collection.Kind
        var cellInfo = layoutInfo[cellKind] as! [NSIndexPath : AnyObject]
        return cellInfo[indexPath] as! UICollectionViewLayoutAttributes
    }
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        switch elementKind {
        case EntryAnnotationReusableView.Collection.Home.Kind :
            fallthrough
        case EntryAnnotationReusableView.Collection.Away.Kind :
            let noteInfo = layoutInfo[elementKind] as! [NSIndexPath : AnyObject]
            return noteInfo[indexPath] as! UICollectionViewLayoutAttributes
        case MatchEntryWinnerReusableView.Collection.Kind :
            let matchInfo = layoutInfo[elementKind] as! [NSIndexPath : AnyObject]
            return matchInfo[indexPath] as! UICollectionViewLayoutAttributes
        default :
            return self.suppsInfo[elementKind]
        }
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        // Game Entries
        let cellKind = GameEntryCell.Collection.Kind
        var cellInfo = [NSIndexPath : AnyObject]()
        cellInfo = layoutInfo[cellKind] as! [NSIndexPath : AnyObject]
        var elements = [UICollectionViewLayoutAttributes]()
        for (indexPath, attributes) in cellInfo {
            if CGRectIntersectsRect(rect, attributes.frame) {
                elements.append(attributes as! UICollectionViewLayoutAttributes)
            }
        }
        
        // Match Entries
        let matchKind = MatchEntryWinnerReusableView.Collection.Kind
        var matchInfo = layoutInfo[matchKind] as! [NSIndexPath : AnyObject]
        for (indexPath, attributes) in matchInfo {
            if CGRectIntersectsRect(rect, attributes.frame) {
                elements.append(attributes as! UICollectionViewLayoutAttributes)
            }
        }
        
        // Home notes
        let homeNoteKind = EntryAnnotationReusableView.Collection.Home.Kind
        var homeInfo = layoutInfo[homeNoteKind] as! [NSIndexPath : AnyObject]
        for (indexPath, attributes) in homeInfo {
            if CGRectIntersectsRect(rect, attributes.frame) {
                elements.append(attributes as! UICollectionViewLayoutAttributes)
            }
        }
        
        // Away notes
        let awayNoteKind = EntryAnnotationReusableView.Collection.Away.Kind
        var awayInfo = layoutInfo[awayNoteKind] as! [NSIndexPath : AnyObject]
        for (indexPath, attributes) in awayInfo {
            if CGRectIntersectsRect(rect, attributes.frame) {
                elements.append(attributes as! UICollectionViewLayoutAttributes)
            }
        }
        
        // Headers and footers
        var headerAttrs = self.suppsInfo[MatchHeaderReusableView.Collection.Kind]!
        if (CGRectIntersectsRect(rect, headerAttrs.frame)) {
            elements.append(headerAttrs)
        }
        elements.append(self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Home]!)
        elements.append(self.suppsInfo[MatchPlayersReusableView.Collection.Kind.Away]!)
        elements.append(self.suppsInfo[ScoreHeaderReusableView.Collection.Kind.Home]!)
        elements.append(self.suppsInfo[ScoreHeaderReusableView.Collection.Kind.Away]!)        
        elements.append(self.suppsInfo[MatchCardViewController.Separator.Kind]!)
        elements.append(self.suppsInfo[MatrixCornerReusableView.Collection.Kind]!)
        let totalAttrs = self.suppsInfo[GameTotalsReusableView.Collection.Kind]!
        if (CGRectIntersectsRect(rect, totalAttrs.frame)) {
            elements.append(totalAttrs)
        }
        return elements
    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}