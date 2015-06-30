//
//  MatchHeaderReusableView.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 23/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class MatchHeaderReusableView : UICollectionReusableView, UIGestureRecognizerDelegate {
    
    static let constantMoreNotification = "NotificationIdentifierOfMoreTapped"
    static let constantKind = "UICollectionElementKindHeader"
    static let constantReuseIdentifier = "MatchHeaderReusableView"
    static let constantCellWidth : CGFloat = UIScreen.mainScreen().bounds.size.width
    static let constantCellHeight : CGFloat = 86
    static let constantDefaultSize = CGSizeMake(constantCellWidth, constantCellHeight)
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var div: UILabel!    
    @IBOutlet weak var division: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBAction func handleMoreTap(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.constantMoreNotification, object: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap"))
        tap.delegate = self
        self.leagueName.userInteractionEnabled = true
        self.leagueName.addGestureRecognizer(tap)
    }
    func handleTap() {
        println("league tapped...")
    }
}