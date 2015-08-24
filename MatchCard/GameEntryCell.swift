//
//  GameEntryCollectionViewCell.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 05/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class GameEntryCell : UICollectionViewCell {
    
    // MARK:- Constants -
    
    struct Collection {
        static let ReuseIdentifier = "GameEntryCell"
        static let Nib = Collection.ReuseIdentifier
        static let Kind = "GameEntryCellKind"
        struct Default {
            struct Font {
                static let Size : CGFloat = 22
            }
            struct Cell {
                static let Width : CGFloat = UIScreen.mainScreen().bounds.size.width / 2.5
                static let Height : CGFloat = 40
                static let Size = CGSizeMake(Cell.Width, Cell.Height)
            }
        }
        struct Edit {
            struct Font {
                static let Size : CGFloat = 38
            }
            struct Cell {
                static let Size = CGSizeMake(Default.Cell.Width + Default.Cell.Width / 4, Default.Cell.Width)
            }
        }
    }
        
    // MARK:- Properties -
    
    @IBOutlet weak var homeBar   : UIView!
    @IBOutlet weak var homeScore : UILabel!
    @IBOutlet weak var awayScore : UILabel!
    @IBOutlet weak var awayBar   : UIView!
    @IBOutlet weak var semicolon: UILabel!
    
    var data : GameEntryModel? {
        didSet {
            homeScore.text = data?.homeEntry
            awayScore.text = data?.awayEntry
            self.updateBars()
            if Common.showColorBounds() {
                self.layer.borderWidth = 1
                self.layer.cornerRadius = 10
                self.layer.borderColor = UIColor.redColor().CGColor
            }
            else {
                self.backgroundColor? = UIColor.clearColor()
                self.homeScore?.backgroundColor = UIColor.clearColor()
                self.awayScore?.backgroundColor = UIColor.clearColor()
            }
        }
    }
    let duration = 0.25
    let startAlpha = CGFloat(0.1)
    
    // MARK:- Methods -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.contentView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.homeScore.layer.anchorPoint = CGPointMake(0.5, 0.5)
        self.homeScore.transform = CGAffineTransformScale(self.homeScore.transform, CGFloat(0.5), CGFloat(0.5))
        self.awayScore.layer.anchorPoint = CGPointMake(0.5, 0.5)
        self.awayScore.transform = CGAffineTransformScale(self.awayScore.transform, CGFloat(0.5), CGFloat(0.5))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_SetLayout:", name: MatchCardViewController.Notification.Identifier.SetLayout, object: nil)        
    }
    
    @objc private func methodOfReceivedNotification_SetLayout(notification : NSNotification){
        var vc = notification.object as! MatchCardViewController
        updateWithLayout(vc.layout)
    }
    func updateWithLayout(layout : LayoutType) {
        self.homeBar.hidden = (layout == .Matrix)
        self.awayBar.hidden = (layout == .Matrix)
        self.semicolon.hidden = (layout != .Matrix)
    }
    func setFontSize(layout : LayoutType) {
        let scale = true
        
        if (scale) {
            self.homeScore.layer.anchorPoint = CGPointMake(0.5, 0.5)
            self.awayScore.layer.anchorPoint = CGPointMake(0.5, 0.5)
        }
        switch (layout){
        case .Edit :
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                if (scale) {
                    self.homeScore.transform = CGAffineTransformScale(self.homeScore.transform, CGFloat(2), CGFloat(2))
                    self.awayScore.transform = CGAffineTransformScale(self.awayScore.transform, CGFloat(2), CGFloat(2))
                } else {
                    self.homeScore.font = self.homeScore.font.fontWithSize(GameEntryCell.Collection.Edit.Font.Size)
                    self.awayScore.font = self.awayScore.font.fontWithSize(GameEntryCell.Collection.Edit.Font.Size)
                }
            })
        default:
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                if (scale) {
                    self.homeScore.transform = CGAffineTransformScale(self.homeScore.transform, CGFloat(0.5), CGFloat(0.5))
                    self.awayScore.transform = CGAffineTransformScale(self.awayScore.transform, CGFloat(0.5), CGFloat(0.5))
                } else {
                    self.homeScore.font = self.homeScore.font.fontWithSize(GameEntryCell.Collection.Default.Font.Size)
                    self.awayScore.font = self.awayScore.font.fontWithSize(GameEntryCell.Collection.Default.Font.Size)
                }
            })
        }
    }
    func updateBars() {
        if (data?.homeToken > data?.awayToken) {
            self.homeBar.backgroundColor = UIColor.greenColor()
            self.awayBar.backgroundColor = UIColor.clearColor()
        } else if (data?.homeToken < data?.awayToken) {
            self.homeBar.backgroundColor = UIColor.clearColor()
            self.awayBar.backgroundColor = UIColor.greenColor()
        } else {
            self.homeBar.backgroundColor = UIColor.clearColor()
            self.awayBar.backgroundColor = UIColor.clearColor()
        }
    }
    func updateHomeScore(toScore score : String) {
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.homeScore.alpha = self.startAlpha
            self.homeBar.alpha = 0
            self.awayBar.alpha = 0
            }) { (Bool) -> Void in
                self.homeScore.alpha = 1
                self.homeScore.text = score
                self.updateBars()
                self.homeBar.alpha = 1
                self.awayBar.alpha = 1
        }
    }
    func updateAwayScore(toScore score : String) {
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.awayScore.alpha = self.startAlpha
            self.homeBar.alpha = 0
            self.awayBar.alpha = 0
            }) { (Bool) -> Void in
                self.awayScore.alpha = 1
                self.awayScore.text = score
                self.updateBars()
                self.homeBar.alpha = 1
                self.awayBar.alpha = 1
        }
    }
    func blink() {
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.homeScore.alpha = 0
            self.awayScore.alpha = 0
        }) { (Bool) -> Void in
            self.homeScore.alpha = 1
            self.awayScore.alpha = 1
        }
    }
}