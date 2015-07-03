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
    struct Collection {
        static let Kind = "UICollectionElementKindHeader"
        static let ReuseIdentifier = "MatchHeaderReusableView"
        static let Nib = Collection.ReuseIdentifier
        struct Cell {
            static let Width : CGFloat = UIScreen.mainScreen().bounds.size.width
            static let Height : CGFloat = 86
            static let Size = CGSizeMake(Cell.Width, Cell.Height)
        }
    }
    struct Notification {
        struct Identifier {
            static let More = "NotificationIdentifierOfMoreTapped"
        }
    }
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var div: UILabel!    
    @IBOutlet weak var division: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBAction func handleMoreTap(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.More, object: nil)
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