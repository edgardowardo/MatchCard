//
//  PlayersController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 31/05/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import UIKit

class MatchPlayersController : NSObject, UICollectionViewDataSource,  UICollectionViewDelegate {
    var elementKind = MatchPlayersReusableView.Collection.Kind.Away
    override init(){
        super.init()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (elementKind == MatchPlayersReusableView.Collection.Kind.Away) {
            return DataManager.sharedInstance.matchCard.awayTeamBag.players.count
        } else {
            return DataManager.sharedInstance.matchCard.homeTeamBag.players.count
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PlayerViewCell.Collection.ReuseIdentifier, forIndexPath: indexPath) as! PlayerViewCell
        if (elementKind == MatchPlayersReusableView.Collection.Kind.Away) {
            var p1 = DataManager.sharedInstance.matchCard.awayTeamBag.players[indexPath.row]
            cell.button.setTitle(p1.key, forState: .Normal)
            if let player =  p1.player {
                cell.button.setImage(player.imageFile, forState: .Normal)
                cell.button.setImage(player.imageFileDark, forState: .Highlighted)
                cell.name.text = player.name
            } else {
                cell.button.setImage(nil, forState: .Normal)
                cell.button.setImage(nil, forState: .Highlighted)
                cell.name.text = "unknown"
            }
        } else {
            var p2 = DataManager.sharedInstance.matchCard.homeTeamBag.players[indexPath.row]
            cell.button.setTitle(p2.key, forState: .Normal)
            if let player =  p2.player {
                cell.button.setImage(player.imageFile, forState: .Normal)
                cell.button.setImage(player.imageFileDark, forState: .Highlighted)
                cell.name.text = player.name
            } else {
                cell.button.setImage(nil, forState: .Normal)
                cell.button.setImage(nil, forState: .Highlighted)
                cell.name.text = "unknown"
            }
        }
        if (self.elementKind == MatchPlayersReusableView.Collection.Kind.Home) {
            cell.contentView.transform = CGAffineTransformMakeScale(-1, 1)
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! PlayerViewCell
        if (DataManager.sharedInstance.hasLeagueName == false) {
//            println("selected \(cell.name.text)")
        }
    }
}
