//
//  ScoreHeaderReusableView.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 24/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class ScoreHeaderReusableView : UICollectionReusableView, UIGestureRecognizerDelegate {
    struct Collection {
        struct Kind {
            static let Home = "UICollectionElementKindHomeScore"
            static let Away = "UICollectionElementKindAwayScore"
        }
        static let ReuseIdentifier = "ScoreHeaderReusableView"
        static let Nib = Collection.ReuseIdentifier
        struct Cell {
            static let Width : CGFloat = UIScreen.mainScreen().bounds.size.width / 2
            static let Height : CGFloat = 92
            static let Size = CGSizeMake(Cell.Width, Cell.Height)
        }
    }
    struct Notification {
        struct Identifier {
            static let ShowTeams = "NotificationIdentifierOfShowTeams"
            static let FadeLabel = MatchHeaderReusableView.Notification.Identifier.FadeLabel
        }
    }
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var teamName: UILabel!
    var kind : String = Collection.Kind.Home
    override func awakeFromNib() {
        super.awakeFromNib()
        // Team name tapped
        let tapTeam = UITapGestureRecognizer(target: self, action: Selector("handleShowTeamsTap"))
        tapTeam.delegate = self
        self.teamName.userInteractionEnabled = true
        self.teamName.addGestureRecognizer(tapTeam)
        // Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("methodOfReceivedNotification_FadeLabel:"), name:MatchHeaderReusableView.Notification.Identifier.FadeLabel, object: nil)
    }
    func handleShowTeamsTap() {
        if let league = DataManager.sharedInstance.matchCard.league {
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.ShowTeams, object: self.kind)
        } else {
            UIAlertView(title: "League is unknown", message: "Set the league?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK").show()
        }
    }
    @objc private func methodOfReceivedNotification_FadeLabel(notification : NSNotification){
        let duration = 0.25
        let startAlpha = CGFloat(0.1)
        let v = notification.object as! UIView
        switch v.tag {
        case MatchCardViewController.Tags.HomeTeam_AllTeams :
            fallthrough
        case MatchCardViewController.Tags.HomeTeam_Filter :
            if self.kind == Collection.Kind.Home {
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.teamName.alpha = startAlpha
                    }) { (Bool) -> Void in
                        NSNotificationCenter.defaultCenter().postNotificationName(MatchCardViewController.Notification.Identifier.ReloadData, object: nil)
                        self.teamName.alpha = CGFloat(1)
                }
            }
        case MatchCardViewController.Tags.AwayTeam :
            if self.kind == Collection.Kind.Away {
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.teamName.alpha = startAlpha
                    }) { (Bool) -> Void in
                        NSNotificationCenter.defaultCenter().postNotificationName(MatchCardViewController.Notification.Identifier.ReloadData, object: nil)
                        self.teamName.alpha = CGFloat(1)
                }
            }
        default :
            break
        }
    }
}

extension ScoreHeaderReusableView : UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.ShowLeagues, object: nil)
        }
    }
}
