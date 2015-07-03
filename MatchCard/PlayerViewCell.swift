//
//  PlayerViewCell.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 22/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class PlayerViewCell : UICollectionViewCell {
    struct Collection {
        static let ReuseIdentifier = "PlayerViewCell"
        static let Nib = Collection.ReuseIdentifier
        static let Size = CGSizeMake(80, 80)
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBAction func handleButtonPressed(sender: UIButton) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.button.layer.cornerRadius = self.button.frame.size.width / 2
        if (!Common.showColorBounds()) {
            self.backgroundColor = UIColor.clearColor()
        }
    }
}
