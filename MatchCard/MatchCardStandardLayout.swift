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
    var alphaCells : CGFloat {
        get { return 1.0 }
    }
    //
    // MARK: Helpers
    //
    func debugMe(fromMethod : String = "") {
//        if let awayPlayersAttrs : AnyObject = self.layoutInfo[MatchPlayersReusableView.constantAwayKind] {
//            if let awayPlayersAttrsCast : UICollectionViewLayoutAttributes = awayPlayersAttrs as? UICollectionViewLayoutAttributes {
//                println("awayPlayers.frame=\(awayPlayersAttrsCast.frame); \(self.getLayoutString()).\(fromMethod)")
//            } else {
//                println("self.layoutInfo not found; \(self.getLayoutString()).\(fromMethod)")
//            }
//        } else {
//            println("self.layoutInfo not found; \(self.getLayoutString()).\(fromMethod)")
//        }
    }
    func yOfPlayersView(proposedContentOffset: CGPoint? = nil) -> CGFloat {
        if (proposedContentOffset != nil) {
            return proposedContentOffset!.y + UIScreen.mainScreen().bounds.size.height - awayPlayersSize().height
        } else {
            let contentOffset = self.collectionView?.contentOffset
            let yPlayers = contentOffset!.y + UIScreen.mainScreen().bounds.size.height - awayPlayersSize().height
            return yPlayers
        }
    }
    func yOfHeadersView() -> CGFloat {
        var yHeader = self.collectionView?.contentOffset.y
        // If pulled upwards pull it upwards. If pulled downwards, don't let it past the screen so it sticks on the CGPointZero
        if yHeader > CGFloat(0) {
            yHeader = CGFloat(0)
        }
        return yHeader!
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
        // FIXME: Can you clean this up. Looks really dirty!!!!
        if let awayPlayersAttrs : AnyObject = self.layoutInfo[MatchPlayersReusableView.constantAwayKind] {
            if let awayPlayersAttrsCast : UICollectionViewLayoutAttributes = awayPlayersAttrs as? UICollectionViewLayoutAttributes {
                awayPlayersAttrsCast.frame.origin.y = yOfPlayersView(proposedContentOffset: proposedContentOffset)
            } else {
                println("self.layoutInfo not found;")
            }
        } else {
            println("self.layoutInfo not found;")
        }
        if let homePlayersAttrs : AnyObject = self.layoutInfo[MatchPlayersReusableView.constantHomeKind] {
            if let homePlayersAttrsCast : UICollectionViewLayoutAttributes = homePlayersAttrs as? UICollectionViewLayoutAttributes {
                homePlayersAttrsCast.frame.origin.y = yOfPlayersView(proposedContentOffset: proposedContentOffset)
            } else {
                println("self.layoutInfo not found;")
            }
        } else {
            println("self.layoutInfo not found;")
        }
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
        layoutInfo[headerKind] = headerAttributes
        // Header Home Score
        // ...
        // Header Away Score
        // ...
        return headerAttributes.frame.size.height
    }
    func prepareLayoutForSupplementaryViews() {
       // Away
        let awayPlayersKind = MatchPlayersReusableView.constantAwayKind
        var awayPlayersAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: awayPlayersKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        awayPlayersAttributes.alpha = 1
        awayPlayersAttributes.frame = CGRectMake(awayPlayersSize().width,
            yOfPlayersView(), awayPlayersSize().width, awayPlayersSize().height)
        awayPlayersAttributes.zIndex += 1
        layoutInfo[awayPlayersKind] = awayPlayersAttributes
        // Home
        let homePlayersKind = MatchPlayersReusableView.constantHomeKind
        var homePlayersAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: homePlayersKind, withIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        homePlayersAttributes.alpha = 0.9
        homePlayersAttributes.frame = CGRectMake(0,
            yOfPlayersView(), homePlayersSize().width, homePlayersSize().height)
        homePlayersAttributes.zIndex += 1
        layoutInfo[homePlayersKind] = homePlayersAttributes
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
        return self.layoutInfo[elementKind] as! UICollectionViewLayoutAttributes
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
        var awayPlayersAttributes = layoutInfo[MatchPlayersReusableView.constantAwayKind] as! UICollectionViewLayoutAttributes
        elements.append(awayPlayersAttributes)
        var homePlayersAttributes = layoutInfo[MatchPlayersReusableView.constantHomeKind] as! UICollectionViewLayoutAttributes
        elements.append(homePlayersAttributes)
        var headerSummaryAttributes = layoutInfo[MatchHeaderReusableView.constantKind] as! UICollectionViewLayoutAttributes
        if (CGRectIntersectsRect(rect, headerSummaryAttributes.frame)) {
            elements.append(headerSummaryAttributes)
        }
        return elements
    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}