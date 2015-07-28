//
//  Common.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 10/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class Common {
    static func showColorBounds() -> Bool {
        return self.readConfiguration("Show Color Bounds") as! Bool
    }
    static func printDebug() -> Bool {
        return self.readConfiguration("Print Debug") as! Bool
    }
    static func readConfiguration(_ name : String = "") -> AnyObject? {
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            return dict[name]
        }
        assertionFailure("Config.plist is not defined")
        return nil
    }
    static func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

extension UITextField {
    public override func becomeFirstResponder() -> Bool {
        ContainerViewController.isPannable = false
        return super.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        ContainerViewController.isPannable = true
        return super.resignFirstResponder()
    }
}

extension UIView {
    var capturedImage : UIImage? {
        get {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
// FIXME: On Club refactor this works!
//            self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates:false)
            self.layer.renderInContext(UIGraphicsGetCurrentContext())
            var snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return snapshotImage
        }
    }
}

extension UICollectionView {
    func selectedCell() -> UICollectionViewCell? {
        let indexPaths : NSArray = self.indexPathsForSelectedItems()
        if indexPaths.count > 0 {
            let indexPath : NSIndexPath = indexPaths[0] as! NSIndexPath
            return self.cellForItemAtIndexPath(indexPath)
        } else {
            return nil
        }
    }
}

extension UIToolbar {
    struct Size {
        static let Width = UIScreen.mainScreen().bounds.size.width
        static let Height = CGFloat(44 )
    }
}


extension UIImage {
    static func changeImageFile(image : UIImage,  withColor : UIColor) -> UIImage? {
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRectMake(0, 0, image.size.width, image.size.height)
        CGContextScaleCTM(context, CGFloat(1), CGFloat(-1))
        CGContextTranslateCTM(context, CGFloat(0), -area.size.height)
        CGContextSaveGState(context)
        CGContextClipToMask(context, area, image.CGImage)
        withColor.set()
        CGContextFillRect(context, area)
        CGContextRestoreGState(context)
        CGContextSetBlendMode(context, kCGBlendModeMultiply)
        CGContextDrawImage(context, area, image.CGImage)
        let colorizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return colorizedImage
    }
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            var newSize:CGSize = size
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
}