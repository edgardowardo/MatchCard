//
//  Common.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 10/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation

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