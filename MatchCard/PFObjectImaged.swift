//
//  PFObjectImaged.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 03/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

class PFObjectImaged : PFObject {
    
    override init() {
        super.init()
    }
    
    convenience init(isAddme : Bool = false, name : String, image : UIImage?)
    {
        self.init()
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