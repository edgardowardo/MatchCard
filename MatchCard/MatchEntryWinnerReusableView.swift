//
//  MatchEntryWinnerReusableView.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 19/08/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

/*
    Visible in Matrix Layout
*/

class MatchEntryWinnerReusableView : UICollectionReusableView {
    
    // MARK:- Constants -
    
    struct Collection {
        static let Kind = "UICollectionElementKind_MatchEntryWinnerReusableView"
        static let ReuseIdentifier = "MatchEntryWinnerReusableView"
        static let Nib = ReuseIdentifier
        struct Cell {
            static let Width : CGFloat = UIScreen.mainScreen().bounds.size.width / 4
            static let Height = CGFloat(160)
            static let Size = CGSizeMake(Width, Height)
        }
    }
    
    // MARK:- Properties -
    
    @IBOutlet weak var leftMedal: UIButton!
    @IBOutlet weak var winnerText: UILabel!
    var data : MatchEntryModel? {
        didSet {
            updateWinner()
        }
    }
    
    // MARK:- Methods -
    
    func updateWinner() {
        let matchCard = DataManager.sharedInstance.matchCard
        if data?.homeToken > 0 {
            winnerText.text = String.substring(ofString: matchCard.homeTeamName, withCount: 7)
        } else if data?.awayToken > 0 {
            winnerText.text = String.substring(ofString: matchCard.awayTeamName, withCount: 7)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftMedal.layer.cornerRadius = self.leftMedal.frame.size.width / 2
    }
    
    func updateBackgroundColorWithSection(section : Int) {
        if section % 2 == 0 {
            backgroundColor = UIColor.whiteColor()
        } else {
            backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2)
        }
    }
}


