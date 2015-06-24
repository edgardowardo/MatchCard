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
    static let constantHomeKind = "UICollectionElementKindHomeScore"
    static let constantAwayKind = "UICollectionElementKindAwayScore"
    static let constantReuseIdentifier = "ScoreHeaderReusableView"
    static let constantCellWidth : CGFloat = UIScreen.mainScreen().bounds.size.width / 2
    static let constantCellHeight : CGFloat = 92
    static let constantDefaultSize = CGSizeMake(constantCellWidth, constantCellHeight)
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var teamName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}