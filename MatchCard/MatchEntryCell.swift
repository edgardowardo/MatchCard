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
    static let constantCellWidth : CGFloat = UIScreen.mainScreen().bounds.size.width / 2
    static let constantCellHeight : CGFloat = 40
    static let constantDefaultSize = CGSizeMake(constantCellWidth, constantCellHeight)
    static let constantEditingSize = CGSizeMake(constantCellWidth, constantCellWidth)
    static let constantLandscapeSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, constantCellHeight)
    
    @IBOutlet weak var homeBar   : UIView?
    @IBOutlet weak var homeScore : CaretlessTextField?
    @IBOutlet weak var awayScore : UITextField?
    @IBOutlet weak var awayBar   : UIView?
    
    weak var data : MatchEntryModel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.clearColor().CGColor
    }
    
}