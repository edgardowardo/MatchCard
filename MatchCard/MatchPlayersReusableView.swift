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

    // TODO: unsure about having 2 kinds. Had to register xib file twice under these 2.
    static let constantHomeKind = "UICollectionElementKindHome"
    static let constantAwayKind = "UICollectionElementKindAway"
    static let constantReuseIdentifier = "MatchPlayersReusableView"
    
    static let constantCellWidth : CGFloat = UIScreen.mainScreen().bounds.size.width / 2
    static let constantCellHeight : CGFloat = 100
    static let constantDefaultSize = CGSizeMake(constantCellWidth, constantCellHeight)
    
    
    @IBOutlet weak var playersCollectionView: UICollectionView?
//    let playersController = PlayersController ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        playersCollectionView?.delegate = playersController
//        playersCollectionView?.dataSource = playersController
    }
}