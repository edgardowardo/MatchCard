//
//  PlayersController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 31/05/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import UIKit

let reuseIdentifier = "PlayerViewCell"
var players = [PlayerModel] ()

class PlayersController : NSObject, UICollectionViewDataSource,  UICollectionViewDelegate {
    
    override init(){
        super.init()
        players.append(PlayerModel(name: "Edgar", image: nil))
        players.append(PlayerModel(name: "Slawomir", image: nil))
        players.append(PlayerModel(name: "Baby", image: nil))
        players.append(PlayerModel(isAddme: true, name: "Add", image: nil))
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        let name = cell.viewWithTag(100) as! UILabel
        name.text = (players[indexPath.row] as PlayerModel).Name
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.cornerRadius = 10
        return cell
    }
}
