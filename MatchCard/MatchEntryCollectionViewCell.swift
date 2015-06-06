//
//  MatchEntryCollectionViewCell.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 05/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class MatchEntryCollectionViewCell : UICollectionViewCell {

    static let constantReuseIdentifier = "MatchEntryViewCell"
    
    @IBOutlet weak var homeBar   : UIView?
    @IBOutlet weak var homeScore : UITextField?
    @IBOutlet weak var awayScore : UITextField?
    @IBOutlet weak var awayBar   : UIView?
}