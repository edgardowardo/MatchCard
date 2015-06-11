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

class MatchCardStandardLayout : UICollectionViewLayout {

    var layoutInfo = [String : AnyObject]()
    
    func cellSize() -> CGSize {
        if (UIDevice.currentDevice().orientation.isLandscape) {
            return MatchEntryCell.constantLandscapeSize
        }
        else {
            return MatchEntryCell.constantDefaultSize
        }
    }
    
    override func prepareLayout() {
        
        let numSections = collectionView?.numberOfSections()
        var cellInfo = [NSIndexPath : AnyObject]()
        let cellKind = MatchEntryCell.constantReuseIdentifier
        let cellSize = self.cellSize()
        
        for var section = 0; section < numSections; section++ {
            let numItems = collectionView?.numberOfItemsInSection(section)
            var totalHeight = CGFloat(0)
            for var indexItem = 0; indexItem < numItems; indexItem++ {
                var indexPath = NSIndexPath(forRow: indexItem, inSection: section)
                var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRectMake(CGFloat(0), CGFloat(totalHeight), cellSize.width, cellSize.height)
                cellInfo[indexPath] = attributes
                totalHeight += cellSize.height
            }
            layoutInfo[cellKind] = cellInfo
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        let count : Int? = collectionView?.numberOfItemsInSection(0)
        let numSections = collectionView?.numberOfSections()
        let cellSize = self.cellSize()
        return CGSizeMake(cellSize.width, cellSize.height * CGFloat(count!))
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let cellKind = MatchEntryCell.constantReuseIdentifier
        var cellInfo = layoutInfo[cellKind] as! [NSIndexPath : AnyObject]
        return cellInfo[indexPath] as! UICollectionViewLayoutAttributes
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
        return elements
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}