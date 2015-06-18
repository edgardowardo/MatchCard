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

    static let constantDefaultFontSize : CGFloat = 22
    static let constantEditFontSize : CGFloat = 38
    static let constantReuseIdentifier = "MatchEntryCell"
    static let constantCellWidth : CGFloat = UIScreen.mainScreen().bounds.size.width / 2.5
    static let constantCellHeight : CGFloat = 40
    static let constantDefaultSize = CGSizeMake(constantCellWidth, constantCellHeight)
    static let constantEditingSize = CGSizeMake(constantCellWidth + constantCellWidth / 4, constantCellWidth)
    static let constantLandscapeSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, constantCellHeight)
    
    @IBOutlet weak var homeBar   : UIView!
    @IBOutlet weak var homeScore : UILabel!
    @IBOutlet weak var homeScoreField : CaretlessTextField!
    @IBOutlet weak var awayScore : UILabel!
    @IBOutlet weak var awayBar   : UIView!
    
    weak var data : MatchEntryModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.contentView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
    }
    
    
    func setFontSize(layout : Layout) {
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
                    self.homeScore.font = self.homeScore.font.fontWithSize(MatchEntryCell.constantEditFontSize)
                    self.awayScore.font = self.awayScore.font.fontWithSize(MatchEntryCell.constantEditFontSize)
                }
            })
        default:
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                if (scale) {
                    self.homeScore.transform = CGAffineTransformScale(self.homeScore.transform, CGFloat(0.5), CGFloat(0.5))
                    self.awayScore.transform = CGAffineTransformScale(self.awayScore.transform, CGFloat(0.5), CGFloat(0.5))
                } else {
                    self.homeScore.font = self.homeScore.font.fontWithSize(MatchEntryCell.constantDefaultFontSize)
                    self.awayScore.font = self.awayScore.font.fontWithSize(MatchEntryCell.constantDefaultFontSize)
                }
            })
        }
        
//        dispatch_async(dispatch_get_main_queue()) {
//            UIView.animateWithDuration(0.25, animations: { () -> Void in
//                switch (layout){
//                case .Edit :
//                    self.homeScore.font = self.homeScore.font.fontWithSize(MatchEntryCell.constantEditFontSize)
//                    self.awayScore.font = self.awayScore.font.fontWithSize(MatchEntryCell.constantEditFontSize)
//                default:
//                    self.homeScore.font = self.homeScore.font.fontWithSize(MatchEntryCell.constantDefaultFontSize)
//                    self.awayScore.font = self.awayScore.font.fontWithSize(MatchEntryCell.constantDefaultFontSize)
//                }
//            })
//        }
    }
    
    func updateBars() {
        if (data?.HomeScore > data?.AwayScore) {
            self.homeBar.backgroundColor = UIColor.greenColor()
            self.awayBar.backgroundColor = UIColor.clearColor()
        } else if (data?.HomeScore < data?.AwayScore) {
            self.homeBar.backgroundColor = UIColor.clearColor()
            self.awayBar.backgroundColor = UIColor.greenColor()
        } else {
            self.homeBar.backgroundColor = UIColor.clearColor()
            self.awayBar.backgroundColor = UIColor.clearColor()
        }
    }
}