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
    convenience init(name : String, image : UIImage?)
    {
        self.init()
        self.name = name
        if let i = image {
            self.imageFile = i
        }
    }
    @NSManaged var name : String
    var imageFileDark : UIImage? {
        get {
            if let image = self.imageFile {
                return UIImage.changeImageFile(image, withColor: UIColor.grayColor())
            }
            return nil
        }
    }
    var imageFileGreen : UIImage? {
        get {
            if let image = self.imageFile {
                return UIImage.changeImageFile(image, withColor: UIColor.greenColor())
            }
            return nil
        }
    }
    
    var imageFile : UIImage?
//    var imageFile: UIImage? {
//        get {
//            let userImageFile = self["imageFile"] as! PFFile
//            var image :UIImage?
//            userImageFile.getDataInBackgroundWithBlock({(imageData: NSData?, error: NSError?) -> Void in
//                if (error == nil) {
//                    image = UIImage(data:imageData!)
//                    println(image)
//                }
//            })
//            return image
//        }
//        set {
//            self.imageFile = newValue
//        }
//    }
}