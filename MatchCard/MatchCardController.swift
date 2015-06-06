//
//  MatchCardController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 05/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

var matchCard = MatchCardModel()

class MatchCardController : NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    override init(){
        super.init()
        matchCard.MatchEntries = [MatchEntryModel]()
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 17, awayScore: 21))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 1, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 2, awayScore: 21))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 3, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 4, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 5, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 6, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 7, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 8, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 9, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 10, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 11, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 12, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 13, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 14, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 15, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 16, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 17, awayScore: 0))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchCard.MatchEntries.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MatchEntryCollectionViewCell.constantReuseIdentifier, forIndexPath: indexPath) as! MatchEntryCollectionViewCell
        
        let matchEntry = matchCard.MatchEntries[indexPath.row]
        cell.homeScore?.text = "\(matchEntry.HomeScore)"
        cell.homeScore?.userInteractionEnabled = false
        cell.awayScore?.text = "\(matchEntry.AwayScore)"
        cell.awayScore?.userInteractionEnabled = false        
        
        println("cell.frame.width=\(cell.frame.width), collectionView.frame.width=\(collectionView.frame.width)")
        cell.backgroundColor? = UIColor.clearColor()
//        cell.layer.borderWidth = 2
//        cell.layer.borderColor = UIColor.whiteColor().CGColor
//        cell.layer.cornerRadius = 10
        
        if (matchEntry.HomeScore > matchEntry.AwayScore) {
            cell.homeBar?.backgroundColor = UIColor.greenColor()
            cell.awayBar?.backgroundColor = UIColor.clearColor()
        } else if (matchEntry.HomeScore < matchEntry.AwayScore) {
            cell.homeBar?.backgroundColor = UIColor.clearColor()
            cell.awayBar?.backgroundColor = UIColor.greenColor()
        } else {
            cell.homeBar?.backgroundColor = UIColor.clearColor()
            cell.awayBar?.backgroundColor = UIColor.clearColor()
        }
        return cell
    }
    
    // TODO: a bit ugly these cell highlights
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.lightGrayColor()
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.clearColor()
    }
    
}

