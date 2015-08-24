//
//  EntryAnnotationReusableView.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 30/07/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class EntryAnnotationReusableView : UICollectionReusableView {

    // MARK:- Constants -
    
    struct Collection {
        struct Home {
            static let Kind = "UICollectionElementKindHomeEntry"
            static let ReuseIdentifier = "EntryAnnotationReusableView"
            static let Nib = Home.ReuseIdentifier
        }
        struct Away {
            static let Kind = "UICollectionElementKindAwayEntry"
            static let ReuseIdentifier = "EntryAnnotationAwayView"
            static let Nib = Away.ReuseIdentifier
        }
        struct Cell {
            static let Width = CGFloat(79)
            static let Height = CGFloat(26)
            static let Size = CGSizeMake(Width, Height)
        }
    }
    
    struct Notification {
        struct Identifier {
            static let ChangedMatchEntry = "NotificationIdentifierOf_ChangedMatchEntry"
            static let TouchedAwayPairs = "NotificationIdentifierOf_TouchedAwayPairs"
            static let TouchedHomePairs = "NotificationIdentifierOf_TouchedHomePairs"
        }
    }
    
    // MARK:- Properties -

    @IBOutlet weak var player1: UIButton!
    @IBOutlet weak var player2: UIButton!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var medalMatchWin: UIButton!
    let duration = 0.25
    var elementKind : String? = Collection.Home.Kind
    var match : MatchEntryModel? {
        didSet {
            if let ek = elementKind {
                if ek == Collection.Home.Kind {
                    self.note.text = match?.homeNote
                    updateButton(self.player1, withPlayer: match?.homePlayer1)
                    updateButton(self.player2, withPlayer: match?.homePlayer2)
                    medalMatchWin.alpha = CGFloat(match!.homeToken)
                } else {
                    self.note.text = match?.awayNote
                    updateButton(self.player1, withPlayer: match?.awayPlayer1)
                    updateButton(self.player2, withPlayer: match?.awayPlayer2)
                    medalMatchWin.alpha = CGFloat(match!.awayToken)
                }
            }
        }
    }
    var game : GameEntryModel? {
        didSet {
            if let ek = elementKind {
                if ek == Collection.Home.Kind {
                    self.note.text = game?.homeNote
                    updateButton(self.player1, withPlayer: game?.homePlayer1)
                    updateButton(self.player2, withPlayer: game?.homePlayer2)
                } else {
                    self.note.text = game?.awayNote
                    updateButton(self.player1, withPlayer: game?.awayPlayer1)
                    updateButton(self.player2, withPlayer: game?.awayPlayer2)
                }
            }
        }
    }
    
    // MARK:- Lifecycles -
    
    @IBAction func touchDownAway(sender: AnyObject) {
        var gameEntryObject : GameEntryModel?
        if let data = game {
            gameEntryObject = data
        } else if let data = match {
            gameEntryObject = data.gameEntries[0]
        }
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.TouchedAwayPairs, object: gameEntryObject!)
        Common.delay(0.5) { () -> () in
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.TouchedHomePairs, object: gameEntryObject!)
        }
    }
    @IBAction func touchDownHome(sender: AnyObject) {
        var gameEntryObject : GameEntryModel?
        if let data = game {
            gameEntryObject = data
        } else if let data = match {
            gameEntryObject = data.gameEntries[0]
        }
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.TouchedHomePairs, object: gameEntryObject!)
        Common.delay(0.5) { () -> () in
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.TouchedAwayPairs, object: gameEntryObject!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.player1.layer.cornerRadius = self.player1.frame.size.width / 2
        self.player2.layer.cornerRadius = self.player2.frame.size.width / 2
        self.medalMatchWin.layer.cornerRadius = self.medalMatchWin.frame.size.width / 2
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("methodOfReceivedNotification_ChangedMatchEntry:"), name:Notification.Identifier.ChangedMatchEntry, object: nil)
    }
    
    // MARK:- Helpers -
    
    @objc private func methodOfReceivedNotification_ChangedMatchEntry(notification : NSNotification){
        if let me = self.match {
            if me == notification.object as! NSObject {
                if self.medalMatchWin.hidden == false {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        self.medalMatchWin.alpha = 0
                    }, completion: { (Bool) -> Void in
                        if self.elementKind == Collection.Home.Kind {
                            self.medalMatchWin.alpha = CGFloat(me.homeToken)
                        } else if self.elementKind == Collection.Away.Kind {
                            self.medalMatchWin.alpha = CGFloat(me.awayToken)
                        }
                    })
                }
            }
        }
    }
    
    func updateButton(button: UIButton, withPlayer playingPlayer: PlayerInMatchModel?) {
        if let player = playingPlayer?.player {
            button.setTitle(player.initials, forState: .Normal)
            if let image = player.imageFile15pt {
                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            } else {
                button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            }
        } else {
            button.setTitle("", forState: .Normal)
        }
        button.setBackgroundImage(playingPlayer?.player?.imageFile15pt, forState: .Normal)
    }
}

class EntryAnnotationAwayView : EntryAnnotationReusableView {

    // MARK:- Lifecycles -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        elementKind = Collection.Away.Kind
    }
}

