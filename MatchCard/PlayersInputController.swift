//
//  PlayersInputController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 17/07/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class PlayersInputController : NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    struct Notification {
        struct Identifier {
            static let ShowRegisteredPlayers = "NotificationIdentifierFor_ShowRegisteredPlayers"
            static let AssignRegisteredPlayer = "NotificationIdentifierFor_AssignRegisteredPlayers"
        }
    }
    struct Collection {
        static let Width = CGFloat(UIScreen.mainScreen().bounds.size.width)
        static let Height = CGFloat(UIScreen.mainScreen().bounds.size.height * 2/5 )
    }
    var elementKind = MatchPlayersReusableView.Collection.Kind.Away
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (elementKind == MatchPlayersReusableView.Collection.Kind.Away) {
            return DataManager.sharedInstance.matchCard.awayTeamBag.team!.allPlayers!.count
        } else {
            return DataManager.sharedInstance.matchCard.homeTeamBag.team!.allPlayers!.count
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PlayerViewCell.Collection.ReuseIdentifier, forIndexPath: indexPath) as! PlayerViewCell
        cell.elementKind = self.elementKind
        var player : PlayerModel
        if (elementKind == MatchPlayersReusableView.Collection.Kind.Away) {
            player = DataManager.sharedInstance.matchCard.awayTeamBag.team!.allPlayers![indexPath.row]
        } else {
            player = DataManager.sharedInstance.matchCard.homeTeamBag.team!.allPlayers![indexPath.row]
        }
        cell.player = player
        cell.button.userInteractionEnabled = false
        cell.button.setTitle(player.initials, forState: .Normal)
        cell.button.setImage(player.imageFile, forState: .Normal)
        if player.isAddition() {
            cell.name.text = "New Player"
        } else {
            cell.name.text = player.name
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! PlayerViewCell
        cell.indexPath = indexPath
        if (cell.player!.isAddition()) {
            // TODO: present modal view            
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.AssignRegisteredPlayer, object: cell)
        }
    }
}