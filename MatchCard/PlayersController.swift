//
//  PlayersController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 31/05/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import UIKit

let reuseIdentifier = "AwayPlayerViewCell"

//let array = ["Edgar", "Michael", "John" , "Barbara", "Add"]
var array = [PlayerModel] ()

class PlayersController : NSObject, UICollectionViewDataSource,  UICollectionViewDelegate {
    
    override init(){
        super.init()
        array.append(PlayerModel(isAddme: true, name: "Add", image: nil))
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        let name = cell.viewWithTag(100) as! UILabel
        name.text = (array[indexPath.row] as PlayerModel).Name
//        name.text = array[indexPath.row]
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.cornerRadius = 10
        return cell
    }
}
