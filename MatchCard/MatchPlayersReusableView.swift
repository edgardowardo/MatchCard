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

    static let constantHomeKind = "UICollectionElementKindHome"
    static let constantAwayKind = "UICollectionElementKindAway"
    static let constantReuseIdentifier = "MatchPlayersReusableView"
    
    static let constantCellWidth : CGFloat = UIScreen.mainScreen().bounds.size.width / 2
    static let constantCellHeight : CGFloat = 100
    static let constantDefaultSize = CGSizeMake(constantCellWidth, constantCellHeight)
    
    let playersController = MatchPlayersController ()
    @IBOutlet weak var playersCollectionView: UICollectionView?
    var elementKind = MatchPlayersReusableView.constantAwayKind {
        didSet {
            playersController.elementKind = self.elementKind
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let playerNib = PlayerViewCell.constantReuseIdentifier
        let nibPlayer = UINib(nibName: playerNib, bundle: nil)
        playersCollectionView?.registerNib(nibPlayer, forCellWithReuseIdentifier: PlayerViewCell.constantReuseIdentifier)
        playersCollectionView?.delegate = playersController
        playersCollectionView?.dataSource = playersController
        var l = MatchPlayersStandardLayout()
        l.scrollDirection = .Horizontal
        l.itemSize = PlayerViewCell.constantDefaultSize
        l.minimumLineSpacing = CGFloat(0) // FIXME: vary on screen size. perhaps from itself? Will cause jerky movement for targetContentOffset if not done.
        playersCollectionView?.collectionViewLayout = l
    }
}

class MatchPlayersStandardLayout : UICollectionViewFlowLayout {
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var newContentOffset = proposedContentOffset
        let divider = PlayerViewCell.constantDefaultSize.width + minimumLineSpacing
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


