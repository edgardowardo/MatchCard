//
//  Player.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 28/05/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

/*
 Data representation of a player.
*/
class PlayerModel : PFObjectImaged, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Player"
    }

    override init () {
        super.init()
    }
    
    var imageFile15px : UIImage?
    override var imageFile : UIImage? {
        didSet {
            if let i = self.imageFile {
                let resizedImage = UIImage.resizeImage(i, size: CGSizeMake(15,15))
                self.imageFile15px = UIImage.circularCropImage(resizedImage)
            }
        }
    }
    
    convenience init(name : String, image : UIImage?)
    {
        self.init()
        self.name = name
        if let i = image {
            self.imageFile = i
            let resizedImage = UIImage.resizeImage(i, size: CGSizeMake(15,15))
            self.imageFile15px = UIImage.circularCropImage(resizedImage)
        }
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    var initials : String {
        get {
            return name.substringToIndex(advance(name.startIndex, 1))
        }
    }
    
    func isAddition() -> Bool {
        return name == "+"
    }
}