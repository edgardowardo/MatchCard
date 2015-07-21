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