//
//  Player.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 28/05/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

class PlayerModel : PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "PlayerModel"
    }

    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(isAddme : Bool, name : String, image : UIImage?)
    {
        super.init()
        self.IsAddme = isAddme
        self.Name = name
//        image
    }
    
    @NSManaged var IsAddme : Bool
    @NSManaged var Name : String
    
    var imageFile: UIImage? {
        get {
            let userImageFile = self["imageFile"] as! PFFile
            var image :UIImage?
            userImageFile.getDataInBackgroundWithBlock({(imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    image = UIImage(data:imageData!)
                    println(image)
                }
            })
            return image
        }
    }
} 