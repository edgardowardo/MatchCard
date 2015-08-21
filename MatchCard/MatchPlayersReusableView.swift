//
//  MatchPlayersReusableView
//  MatchCard
//
//  Created by EDGARDO AGNO on 07/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol MatchPlayersReusableViewDelegate {
    func needsPositionSelected()
    func clearPlayerPositionCell()
}

class MatchPlayersReusableView : UICollectionReusableView {
    struct Collection {
        struct  Kind {
            static let Home = "UICollectionElementKindHome"
            static let Away = "UICollectionElementKindAway"
        }
        static let ReuseIdentifier = "MatchPlayersReusableView"
        static let Nib = Collection.ReuseIdentifier
        struct Matrix{
            struct  Cell {
                struct Away {
                    static let Width = CGFloat(UIScreen.mainScreen().bounds.size.width)
                    static let Height = Collection.Cell.Height
                    static let Size = CGSizeMake(Width, Height)
                }
                struct Home {
                    static let Width = CGFloat(UIScreen.mainScreen().bounds.size.width / 4)
                    static let Height = GameEntryCell.Collection.Default.Cell.Height * (9 + 3 + 4)
                    static let Size = CGSizeMake(Width, Height)
                }
            }
        }
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
    struct Notification {
        struct Identifier {
            static let Deselect = "NotificationIdentifierOf_Deselect"
            static let Reload = "NotificationIdentifierOf_Reload"
        }
    }
    @IBOutlet weak var shadowRightCasted: UIImageView!
    @IBOutlet weak var playersCollectionView: UICollectionView?
    var elementKind = Collection.Kind.Away {
        didSet {
            self.shadowRightCasted.hidden = (elementKind == Collection.Kind.Home)
        }
    }
    var delegate : MatchPlayersReusableViewDelegate?
    var layouts : [LayoutType : UICollectionViewFlowLayout] = [.Standard : MatchPlayersStandardLayout(), .Edit : PlayersEditLayout(), .MatrixHomePlayers : HomePlayersMatrixLayout(), .MatrixAwayPlayers : AwayPlayersMatrixLayout()]
    var layout : LayoutType = .Standard {
        didSet {
            self.playersCollectionView?.setCollectionViewLayout(self.layouts[self.layout]!, animated: true)
            if layout == .Standard {
                // Calculate the content inset so the 2 players are even on a standard layout, since minimum line spacing is applied either left or right but not at the same time.
                let containerWidth = MatchPlayersReusableView.Collection.Cell.Width
                let width2Players = PlayerViewCell.Collection.Size.width * 2
                let leftInset = CGFloat( (containerWidth - width2Players) / 3 )
                playersCollectionView?.contentInset = UIEdgeInsetsMake(0, leftInset, 0, 0 )
            }
        }
    }
    var layoutOfMatchCard : LayoutType = .Standard
    override func awakeFromNib() {
        super.awakeFromNib()
        let nibPlayer = UINib(nibName: PlayerViewCell.Collection.Nib, bundle: nil)
        playersCollectionView?.registerNib(nibPlayer, forCellWithReuseIdentifier: PlayerViewCell.Collection.ReuseIdentifier)
        playersCollectionView?.scrollsToTop = false
        playersCollectionView?.delegate = self
        playersCollectionView?.dataSource = self
        
        self.layout = .Standard
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_Clear:", name: MenuItem.Notification.Identifier.Clear, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_SetLayout:", name: MatchCardViewController.Notification.Identifier.SetLayout, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_Deselect:", name: Notification.Identifier.Deselect, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_Reload:", name: Notification.Identifier.Reload, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_AssignRegisteredPlayer:", name:PlayersInputController.Notification.Identifier.AssignRegisteredPlayer, object: nil)
    }
    @objc private func methodOfReceivedNotification_AssignRegisteredPlayer(notification: NSNotification){
        var registeredPlayerCell = notification.object as? PlayerViewCell
        if registeredPlayerCell?.elementKind == self.elementKind {
            if let c = playersCollectionView?.selectedCell() {
                var cell = c as! PlayerViewCell
                if let p = cell.playingPlayer {
                    p.player = registeredPlayerCell?.player
                    cell.fade()
                    NSNotificationCenter.defaultCenter().postNotificationName(MatchCardViewController.Notification.Identifier.RemoveRegisteredPlayer, object: registeredPlayerCell)
                    NSNotificationCenter.defaultCenter().postNotificationName(MatchCardViewController.Notification.Identifier.ReloadData, object: nil)
                }
            }
            else {
                delegate?.needsPositionSelected()
            }
        }
        delegate?.clearPlayerPositionCell()
     }
    @objc private func methodOfReceivedNotification_Deselect(notification: NSNotification){
        if let c = playersCollectionView?.selectedCell() {
            var cell = c as! PlayerViewCell
            let i = playersCollectionView?.indexPathForCell(cell)
            playersCollectionView?.deselectItemAtIndexPath(i, animated: true)
            cell.updateButton()
        }
    }
    @objc private func methodOfReceivedNotification_Reload(notification: NSNotification){
        playersCollectionView?.reloadData()
    }
    @objc private func methodOfReceivedNotification_Clear(notification: NSNotification){
        playersCollectionView?.reloadData()
    }
    @objc private func methodOfReceivedNotification_SetLayout(notification : NSNotification){
        self.playersCollectionView?.scrollEnabled = true
        
        var vc = notification.object as! MatchCardViewController
        self.layoutOfMatchCard = vc.layout
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
            self.shadowRightCasted.hidden = true
        case .Matrix :
            self.shadowRightCasted.hidden = true
            self.playersCollectionView?.scrollEnabled = false
            self.playersCollectionView?.reloadData()
            if self.elementKind == MatchPlayersReusableView.Collection.Kind.Home {
                self.layout = .MatrixHomePlayers                
            } else if self.elementKind == MatchPlayersReusableView.Collection.Kind.Away {
                self.layout = .MatrixAwayPlayers
            }
        default :
            self.playersCollectionView?.reloadData()
            self.layout = .Standard
            self.shadowRightCasted.hidden = (elementKind == Collection.Kind.Home)
        }
    }
}

// MARK:
// MARK: UICollectionView delegates
// MARK:
extension MatchPlayersReusableView : UICollectionViewDataSource,  UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (elementKind == MatchPlayersReusableView.Collection.Kind.Away) {
            if self.layoutOfMatchCard == .Matrix {
                return DataManager.sharedInstance.matchCard.mockedAwayPairs.count
            } else {
                return DataManager.sharedInstance.matchCard.awayTeamBag.players!.count
            }
        } else {
            if self.layoutOfMatchCard == .Matrix {
                return DataManager.sharedInstance.matchCard.mockedHomePairs.count
            } else {
                return DataManager.sharedInstance.matchCard.homeTeamBag!.players!.count
            }
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PlayerViewCell.Collection.ReuseIdentifier, forIndexPath: indexPath) as! PlayerViewCell
        cell.elementKind = self.elementKind
        if self.layoutOfMatchCard == .Matrix {
            if (elementKind == MatchPlayersReusableView.Collection.Kind.Home) {
                cell.player = DataManager.sharedInstance.matchCard.mockedHomePairs[indexPath.row]
            } else {
                cell.player = DataManager.sharedInstance.matchCard.mockedAwayPairs[indexPath.row]
            }
        } else {
            if (elementKind == MatchPlayersReusableView.Collection.Kind.Away) {
                var p1 = DataManager.sharedInstance.matchCard.awayTeamBag.players?[indexPath.row]
                cell.playingPlayer = p1
                cell.buttonKey.setTitle(p1?.key, forState: .Normal)
            } else {
                var p2 = DataManager.sharedInstance.matchCard.homeTeamBag!.players?[indexPath.row]
                cell.playingPlayer = p2
                cell.buttonKey.setTitle(p2?.key, forState: .Normal)
            }
        }
        if let i = cell.player?.imageFile {
            cell.buttonKey.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else {
            cell.buttonKey.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        }
        if (self.elementKind == MatchPlayersReusableView.Collection.Kind.Home) {
            cell.contentView.transform = CGAffineTransformMakeScale(-1, 1)
        }
        cell.updateButton()
        if self.layoutOfMatchCard == .Matrix {
            cell.button.backgroundColor = UIColor.clearColor()
            cell.buttonKey.backgroundColor = UIColor.clearColor()
            switch indexPath.row {
            case 0:
                cell.buttonKey.setTitle("A", forState: .Normal)
            case 1:
                cell.buttonKey.setTitle("B", forState: .Normal)
            case 2:
                cell.buttonKey.setTitle("C", forState: .Normal)
            default :
                assertionFailure("index is out of bounds calculating the cell names")
            }
        }        
        return cell
    }
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.layoutOfMatchCard != .Matrix
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.layoutOfMatchCard != .Matrix
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! PlayerViewCell
        NSNotificationCenter.defaultCenter().postNotificationName(PlayersInputController.Notification.Identifier.ShowRegisteredPlayers, object: cell)
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! PlayerViewCell
        // unhighlight the others
        for c in collectionView.visibleCells()  {
            if let ce = c as? PlayerViewCell {
                ce.updateButtonClear()
            }
        }
        cell.updateButton(highlighted: true)
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! PlayerViewCell
        cell.updateButton()
    }
}