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
    struct Notification {
        struct Identifier {
            static let Clear = "NotificationIdentifierForClear"
        }
    }
    let playersController = MatchPlayersController ()
    @IBOutlet weak var playersCollectionView: UICollectionView?
    var elementKind = MatchPlayersReusableView.Collection.Kind.Away {
        didSet {
            playersController.elementKind = self.elementKind
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let playerNib = PlayerViewCell.Collection.Nib
        let nibPlayer = UINib(nibName: playerNib, bundle: nil)
        playersCollectionView?.registerNib(nibPlayer, forCellWithReuseIdentifier: PlayerViewCell.Collection.ReuseIdentifier)
        playersCollectionView?.delegate = playersController
        playersCollectionView?.dataSource = playersController
        var l = MatchPlayersStandardLayout()
        l.scrollDirection = .Horizontal
        l.itemSize = PlayerViewCell.Collection.Size
        l.minimumLineSpacing = CGFloat(0) // FIXME: vary on screen size. perhaps from itself? Will cause jerky movement for targetContentOffset if not done.
        playersCollectionView?.collectionViewLayout = l
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clearMethodOfReceivedNotification:", name: MatchPlayersReusableView.Notification.Identifier.Clear, object: nil)
    }
    @objc private func clearMethodOfReceivedNotification(notification: NSNotification){
        playersCollectionView?.reloadData()
    }
}

class MatchPlayersStandardLayout : UICollectionViewFlowLayout {
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var newContentOffset = proposedContentOffset
        let divider = PlayerViewCell.Collection.Size.width + minimumLineSpacing
        let modulus = proposedContentOffset.x % divider
        let division = proposedContentOffset.x / divider
        if modulus < divider / 2 {
            newContentOffset.x = floor(division) * divider
        } else {
            newContentOffset.x = ceil(division) * divider
        }
        return newContentOffset
    }
}

extension MatchPlayersReusableView: SidePanelViewControllerDelegate {
    func itemSelected(item: MenuItem) {
        switch item.type {
        case .Clear :
            playersCollectionView?.reloadData()
        case .ClearScores :
            break
        }
    }
}
