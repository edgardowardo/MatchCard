//
//  ScoreHeaderReusableView.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 24/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class ScoreHeaderReusableView : UICollectionReusableView {
    struct Collection {
        struct Kind {
            static let Home = "UICollectionElementKindHomeScore"
            static let Away = "UICollectionElementKindAwayScore"
        }
        static let ReuseIdentifier = "ScoreHeaderReusableView"
        static let Nib = Collection.ReuseIdentifier
        struct Cell {
            static let Width : CGFloat = UIScreen.mainScreen().bounds.size.width / 2
            static let Height : CGFloat = 92
            static let Size = CGSizeMake(Cell.Width, Cell.Height)
        }
    }
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var teamName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}