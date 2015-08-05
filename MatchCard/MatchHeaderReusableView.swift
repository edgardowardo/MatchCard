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
    // MARK: Structured constants
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
            static let ShowLocations_Map = "NotificationIdentifierOfShowLocationsMap"
            static let ShowLocations_Picker = "NotificationIdentifierOfShowLocationsPicker"
            static let FadeLabel = "NotificationIdentifierFadeLabel"
        }
    }
    // MARK: Properties
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var division: UILabel!
    @IBOutlet weak var divisionValue: UILabel!
    @IBOutlet weak var divOrdinal: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBAction func handleMoreTap(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.More, object: nil)
    }
    @IBAction func handlePinTap(sender: AnyObject) {
        checkLeagueBeforeDoing() {
            NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.ShowLocations_Map, object: nil)
        }
    }
    // MARK: Lifecycles
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
        self.division.userInteractionEnabled = true
        self.division.addGestureRecognizer(tapDiv)
        self.divisionValue.userInteractionEnabled = true
        self.divisionValue.addGestureRecognizer(tapDiv)
        // Location tapped
        let tapLocation = UITapGestureRecognizer(target: self, action: Selector("handleShowLocations_Picker"))
        self.location.userInteractionEnabled = true
        self.location.addGestureRecognizer(tapLocation)
        // Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("methodOfReceivedNotification_FadeLabel:"), name:MatchHeaderReusableView.Notification.Identifier.FadeLabel, object: nil)
    }
    // MARK: Helpers
    func checkLeagueBeforeDoing( function :  () -> () ) {
        if let league = DataManager.sharedInstance.matchCard.league {
            function()
        } else {
            UIAlertView(title: "League is unknown", message: "Set the league?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK").show()
        }
    }
    @objc private func methodOfReceivedNotification_FadeLabel(notification : NSNotification){
        let duration = 0.25
        let startAlpha = CGFloat(0.1)
        let v = notification.object as! UIView
        switch v.tag {
        case MatchCardViewController.Tags.League :
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.leagueName.alpha = startAlpha
                }) { (Bool) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(MatchCardViewController.Notification.Identifier.ReloadData, object: nil)
                    self.leagueName.alpha = CGFloat(1)
            }
        case MatchCardViewController.Tags.Division :
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.divisionValue.alpha = startAlpha
                self.divOrdinal.alpha = startAlpha
                }) { (Bool) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(MatchCardViewController.Notification.Identifier.ReloadData, object: nil)
                    self.divisionValue.alpha = CGFloat(1)
                    self.divOrdinal.alpha = CGFloat(1)
            }
        case MatchCardViewController.Tags.Location :
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.location.alpha = startAlpha
                self.locationButton.alpha = startAlpha
                }) { (Bool) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(MatchCardViewController.Notification.Identifier.ReloadData, object: nil)
                    self.location.alpha = CGFloat(1)
                    self.locationButton.alpha = CGFloat(1)
            }
        default :
            break
        }
    }
    func handleShowLeagueTap() {
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.ShowLeagues, object: nil)
    }
    func handleShowDivisions() {
        checkLeagueBeforeDoing() {
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.ShowDivisions, object: nil)
        }
    }
    func handleShowLocations_Picker() {
        checkLeagueBeforeDoing() {
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.ShowLocations_Picker, object: nil)
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
