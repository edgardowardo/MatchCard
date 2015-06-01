//
//  PlayerCollectionViewCell.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 01/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import UIKit

class RightAlignedCollectionViewCell : UICollectionViewCell {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.transform = CGAffineTransformMakeScale(-1, 1)
    }
}
