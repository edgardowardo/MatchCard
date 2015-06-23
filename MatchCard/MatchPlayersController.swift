//
//  PlayersController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 31/05/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import UIKit

var players = [PlayerModel] ()

class MatchPlayersController : NSObject, UICollectionViewDataSource,  UICollectionViewDelegate {
    var elementKind = MatchPlayersReusableView.constantAwayKind
    override init(){
        super.init()
        players.append(PlayerModel(name: "Edgar", image: nil))
        players.append(PlayerModel(name: "Slawomir", image: nil))
        players.append(PlayerModel(name: "B3", image: nil))
        players.append(PlayerModel(name: "B4", image: nil))
        players.append(PlayerModel(name: "C5", image: nil))
        players.append(PlayerModel(name: "C6", image: nil))
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PlayerViewCell.constantReuseIdentifier, forIndexPath: indexPath) as! PlayerViewCell
        cell.name.text = (players[indexPath.row] as PlayerModel).Name
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.cornerRadius = 10
        if (self.elementKind == MatchPlayersReusableView.constantHomeKind ) {
            cell.contentView.transform = CGAffineTransformMakeScale(-1, 1)
        }
        return cell
    }
}
