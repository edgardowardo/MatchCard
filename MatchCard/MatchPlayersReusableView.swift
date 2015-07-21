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
            struct  Assignment {
                static let Width = CGFloat(UIScreen.mainScreen().bounds.size.width)
                static let Height = CGFloat(UIScreen.mainScreen().bounds.size.height * 3/5 )
            }
        }
    }
    @IBOutlet weak var playersCollectionView: UICollectionView?
    var elementKind = MatchPlayersReusableView.Collection.Kind.Away
    var layouts : [LayoutType : UICollectionViewFlowLayout] = [.Standard : MatchPlayersStandardLayout(), .Edit : MatchPlayersStandardLayout()]
    var layout : LayoutType = .Standard {
        didSet {
            self.playersCollectionView?.setCollectionViewLayout(self.layouts[self.layout]!, animated: true)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let nibPlayer = UINib(nibName: PlayerViewCell.Collection.Nib, bundle: nil)
        playersCollectionView?.registerNib(nibPlayer, forCellWithReuseIdentifier: PlayerViewCell.Collection.ReuseIdentifier)
        playersCollectionView?.delegate = self
        playersCollectionView?.dataSource = self

        var standardLayout = self.layouts[.Standard]!
        standardLayout.scrollDirection = .Horizontal
        standardLayout.itemSize = PlayerViewCell.Collection.Size
        standardLayout.minimumLineSpacing = CGFloat(0)
        
        var editLayout = self.layouts[.Edit]!
        editLayout.scrollDirection = .Vertical
        editLayout.itemSize = PlayerViewCell.Collection.Size
        editLayout.minimumLineSpacing = CGFloat(10)
        editLayout.sectionInset = UIEdgeInsetsMake(25, 50, 0, 50)
        
        self.layout = .Standard
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_Clear:", name: MenuItem.Notification.Identifier.Clear, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_SetLayout:", name: MatchCardViewController.Notification.Identifier.SetLayout, object: nil)
    }
    @objc private func methodOfReceivedNotification_Clear(notification: NSNotification){
        playersCollectionView?.reloadData()
    }
    @objc private func methodOfReceivedNotification_SetLayout(notification : NSNotification){
        var vc = notification.object as! MatchCardViewController
        switch vc.layout {
        case .HomePlayers :
            if elementKind == MatchPlayersReusableView.Collection.Kind.Away {
                break
            }
            self.layout = .Edit
        case .AwayPlayers :
            if elementKind == MatchPlayersReusableView.Collection.Kind.Home {
                break
            }
            self.layout = .Edit
        default :
            self.layout = .Standard
        }
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
        //        if (DataManager.sharedInstance.hasLeagueName == false) {
        //            println("selected \(cell.name.text)")
        //        }
    }
}

