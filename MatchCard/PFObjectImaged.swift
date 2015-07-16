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
                let color = UIColor.grayColor()
                UIGraphicsBeginImageContext(image.size)
                let context = UIGraphicsGetCurrentContext()
                let area = CGRectMake(0, 0, image.size.width, image.size.height)
                CGContextScaleCTM(context, CGFloat(1), CGFloat(-1))
                CGContextTranslateCTM(context, CGFloat(0), -area.size.height)
                CGContextSaveGState(context)
                CGContextClipToMask(context, area, image.CGImage)
                color.set()
                CGContextFillRect(context, area)
                CGContextRestoreGState(context)
                CGContextSetBlendMode(context, kCGBlendModeMultiply)
                CGContextDrawImage(context, area, image.CGImage)
                let colorizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return colorizedImage
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