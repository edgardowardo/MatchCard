//
//  MatchEntryCollectionHeaderViewCell.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 07/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

// TODO: MatchHomePlayersLayout and MatchAwayPlayersLayout calculating left aligned and right aligned and diagonal origins

class MatchPlayersReusableView : UICollectionReusableView {
    struct Collection {
        struct  Kind {
            static let Home = "UICollectionElementKindHome"
            static let Away = "UICollectionElementKindAway"
        }
        static let ReuseIdentifier = "MatchPlayersReusableView"
        static let Nib = Collection.ReuseIdentifier
        struct Cell {
            static let Width = CGFloat(UIScreen.mainScreen().bounds.size.width / 2)
            static let Height = CGFloat(100)
            static let Size = CGSizeMake(Width, Height)
        }
    }
    @IBOutlet weak var playersCollectionView: UICollectionView?
    var elementKind = MatchPlayersReusableView.Collection.Kind.Away
    override func awakeFromNib() {
        super.awakeFromNib()
        let playerNib = PlayerViewCell.Collection.Nib
        let nibPlayer = UINib(nibName: playerNib, bundle: nil)
        playersCollectionView?.registerNib(nibPlayer, forCellWithReuseIdentifier: PlayerViewCell.Collection.ReuseIdentifier)
        playersCollectionView?.delegate = self
        playersCollectionView?.dataSource = self
        var l = MatchPlayersStandardLayout()
        l.scrollDirection = .Horizontal
        l.itemSize = PlayerViewCell.Collection.Size
        l.minimumLineSpacing = CGFloat(0) // FIXME: vary on screen size. perhaps from itself? Will cause jerky movement for targetContentOffset if not done.
        playersCollectionView?.collectionViewLayout = l
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_Clear:", name: MenuItem.Notification.Identifier.Clear, object: nil)
    }

    @objc private func methodOfReceivedNotification_Clear(notification: NSNotification){
        playersCollectionView?.reloadData()
    }
}

extension MatchPlayersReusableView : UICollectionViewDataSource,  UICollectionViewDelegate {
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
        cell.elementKind = self.elementKind
        if (elementKind == MatchPlayersReusableView.Collection.Kind.Away) {
            var p1 = DataManager.sharedInstance.matchCard.awayTeamBag.players[indexPath.row]
            cell.button.setTitle(p1.key, forState: .Normal)
            cell.player = p1
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
            cell.player = p2
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
        //        if (DataManager.sharedInstance.hasLeagueName == false) {
        //            println("selected \(cell.name.text)")
        //        }
    }
}

