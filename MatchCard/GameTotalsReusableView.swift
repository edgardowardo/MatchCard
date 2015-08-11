//
//  GameTotalsReusableView.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 11/08/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class GameTotalsReusableView : UICollectionReusableView {
    
    // MARK:- Constants -
    
    struct Collection {
        static let Kind = "UICollectionElementKind_GameTotals"
        static let ReuseIdentifier = "GameTotalsReusableView"
        static let Nib = ReuseIdentifier
        struct Cell {
            static let Width : CGFloat = UIScreen.mainScreen().bounds.size.width
            static let Height : CGFloat = 40
            static let Size = CGSizeMake(Width, Height)
        }
    }
    @IBOutlet weak var homeTotal: UILabel!
    @IBOutlet weak var awayTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}