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
            static let ShowLeagues = "NotificationIdentifierOfShowLeagues"
            static let ShowDivisions = "NotificationIdentifierOfShowDivisions"
            static let ShowClubs = "NotificationIdenfifierOfShowClubs"
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
        // League tapped
        let tapLeague = UITapGestureRecognizer(target: self, action: Selector("handleShowLeagueTap"))
        tapLeague.delegate = self
        self.leagueName.userInteractionEnabled = true
        self.leagueName.addGestureRecognizer(tapLeague)
        // Division tapped
        let tapDiv = UITapGestureRecognizer(target: self, action: Selector("handleShowDivisions"))
        tapDiv.delegate = self
        self.div.userInteractionEnabled = true
        self.div.addGestureRecognizer(tapDiv)
        self.division.userInteractionEnabled = true
        self.division.addGestureRecognizer(tapDiv)
    }
    // MARK: Helpers
    func handleShowLeagueTap() {
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.ShowLeagues, object: nil)
    }
    func handleShowDivisions() {
        println("handleShowDivisions")
        if let league = DataManager.sharedInstance.matchCard.league {
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.ShowDivisions, object: nil)
        } else {
            UIAlertView(title: "League is unknown", message: "Set the league?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK").show()
        }
    }
}

extension MatchHeaderReusableView : UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.handleShowLeagueTap()
        }
    }
    
}
