//
//  PlayersController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 31/05/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import UIKit

class MatchPlayersController : NSObject, UICollectionViewDataSource,  UICollectionViewDelegate {
    var elementKind = MatchPlayersReusableView.constantAwayKind
    override init(){
        super.init()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (elementKind == MatchPlayersReusableView.constantAwayKind) {
            return DataManager.sharedInstance.matchCard.awayTeamBag.players.count
        } else {
            return DataManager.sharedInstance.matchCard.homeTeamBag.players.count
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PlayerViewCell.constantReuseIdentifier, forIndexPath: indexPath) as! PlayerViewCell
        
        if (elementKind == MatchPlayersReusableView.constantAwayKind) {
            var p1 = DataManager.sharedInstance.matchCard.awayTeamBag.players[indexPath.row]
            cell.button.titleLabel?.text = p1.key
            cell.name.text = p1.player.Name
        } else {
            var p2 = DataManager.sharedInstance.matchCard.homeTeamBag.players[indexPath.row]
            cell.button.titleLabel?.text = p2.key
            cell.name.text = p2.player.Name
        }
        if (self.elementKind == MatchPlayersReusableView.constantHomeKind ) {
            cell.contentView.transform = CGAffineTransformMakeScale(-1, 1)
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! PlayerViewCell
        if (DataManager.sharedInstance.hasLeagueName == false) {
            println("selected \(cell.name.text)")
        }
    }
}
