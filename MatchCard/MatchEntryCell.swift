//
//  MatchEntryCollectionViewCell.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 05/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class MatchEntryCell : UICollectionViewCell {

    static let constantReuseIdentifier = "MatchEntryCell"
    static let constantCellWidth : CGFloat = UIScreen.mainScreen().bounds.size.width
    static let constantCellHeight : CGFloat = 40
    static let constantDefaultSize = CGSizeMake(constantCellWidth, constantCellHeight)
    static let constantEditingSize = CGSizeMake(constantCellWidth, constantCellWidth)
    static let constantLandscapeSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, constantCellHeight)
    
    @IBOutlet weak var margin    : UIView?
    @IBOutlet weak var homeBar   : UIView?
    @IBOutlet weak var homeScore : CaretlessTextField?
    @IBOutlet weak var awayScore : UITextField?
    @IBOutlet weak var awayBar   : UIView?
    
    weak var data : MatchEntryModel?
}