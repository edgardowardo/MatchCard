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
    var playingPlayer : PlayerInMatchModel? {
        didSet {
            self.player = self.playingPlayer?.player
        }
    }
    var player : PlayerModel? {
        didSet {
            self.updateButton()
        }
    }
    var indexPath : NSIndexPath?
    var elementKind = MatchPlayersReusableView.Collection.Kind.Away
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonKey: UIButton!
    @IBAction func handleButtonPressed(sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.button.userInteractionEnabled = false
        self.button.backgroundColor = UIColor.lightTextColor()
        self.button.layer.cornerRadius = self.button.frame.size.width / 2
        if (!Common.showColorBounds()) {
            self.backgroundColor = UIColor.clearColor()
        }
    }
    
    func updateButton(highlighted : Bool = false) {
        if self.selected || highlighted {
            self.button.backgroundColor = UIColor.greenColor()
            if let p = self.player {
                self.name.text = p.name
                self.button.setImage(p.imageFileGreen, forState: .Normal)
                if (p.name != "+") {
                    self.buttonKey.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                }
            } else {
                self.name.text = "unknown"
                self.button.setImage(nil, forState: .Normal)
            }
        } else {
            self.updateButtonClear()
        }
    }
    func updateButtonClear() {
        self.button.backgroundColor = UIColor.lightTextColor()
        if let p = self.player {
            self.name.text = p.name
            self.button.setImage(p.imageFile, forState: .Normal)
            if (p.name != "+") {
                self.button.backgroundColor = UIColor.grayColor()
                self.buttonKey.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            }
        } else {
            self.name.text = "unknown"
            self.button.setImage(nil, forState: .Normal)
        }
    }
    func fade() {
        let duration = 0.25
        let startAlpha = CGFloat(0.1)
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.button.alpha = startAlpha
            self.name.alpha = startAlpha
            }) { (Bool) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(MatchPlayersReusableView.Notification.Identifier.Reload, object: nil)
                self.button.alpha = CGFloat(1)
                self.name.alpha = CGFloat(1)
        }
    }
}
