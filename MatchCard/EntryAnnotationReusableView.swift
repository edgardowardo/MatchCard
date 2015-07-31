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

    // MARK:- Properties -

    @IBOutlet weak var player1: UIButton!
    @IBOutlet weak var player2: UIButton!
    @IBOutlet weak var note: UILabel!
    var elementKind : String? = Collection.Home.Kind
    var data : MatchEntryModel? {
        didSet {
            if let ek = elementKind {
                if ek == Collection.Home.Kind {
                    self.note.text = data?.homeNote
                    updateButton(self.player1, withPlayer: data?.homePlayer1)
                    updateButton(self.player2, withPlayer: data?.homePlayer2)
                } else {
                    self.note.text = data?.awayNote
                    updateButton(self.player1, withPlayer: data?.awayPlayer1)
                    updateButton(self.player2, withPlayer: data?.awayPlayer2)
                }
            }
        }
    }
    func updateButton(button: UIButton, withPlayer playingPlayer: PlayerInMatchModel?) {
        if let player = playingPlayer?.player {
            button.setTitle(player.initials, forState: .Normal)
            if let image = player.imageFile15px {
                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            } else {
                button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            }
        } else {
            button.setTitle("", forState: .Normal)
        }
        button.setBackgroundImage(playingPlayer?.player?.imageFile15px, forState: .Normal)
    }
    
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
        
    // MARK:- Lifecycles -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.player1.layer.cornerRadius = self.player1.frame.size.width / 2
        self.player2.layer.cornerRadius = self.player2.frame.size.width / 2
    }
}

class EntryAnnotationAwayView : EntryAnnotationReusableView {

    // MARK:- Lifecycles -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        elementKind = Collection.Away.Kind
    }
}

