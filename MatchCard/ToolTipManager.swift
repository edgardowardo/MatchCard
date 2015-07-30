//
//  ToolTipManager.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 29/07/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

@objc
class ToolTipManager {
    static let sharedInstance = ToolTipManager()
    struct Keys {
        static let MapPin = "MapPin"
        static let PlayerPosition = "PlayerPosition"
        static let CurrentKey = "CurrentKey"
    }
    private struct ToolTipEntry {
        var message : String
        init (message : String) {
            self.message = message
        }
    }
    private var tooltips = Dictionary<String, ToolTipEntry>()
    private var _currentKey : String?
    private var currentKey : String? {
        set {
            _currentKey = newValue
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue, forKey: Keys.CurrentKey)
        }
        get {
            return _currentKey
        }
    }
    init() {
        self.tooltips[Keys.MapPin] = ToolTipEntry(message: "Select the venue and home club in a map.")
        self.tooltips[Keys.PlayerPosition] = ToolTipEntry(message: "Select player position then a registered player to assign.")
        let defaults = NSUserDefaults.standardUserDefaults()
        if let ck = defaults.stringForKey(Keys.CurrentKey) {
            self.currentKey = ck
        } else {
            self.currentKey = Keys.MapPin
            defaults.setObject(self.currentKey, forKey: Keys.CurrentKey)
        }
    }
    func resetTooltips() {
        for (key, entry) in self.tooltips {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(false, forKey: key)
        }
    }
    func nextOfKey(key : String) -> String? {
        switch key {
        case Keys.MapPin :
            return Keys.PlayerPosition
        case Keys.PlayerPosition :
            return nil
        default :
            return nil
        }
    }
    func needsDisplayTipView(withKey: String, forView: UIView, withinSuperview: UIView?) {
        if let ck = self.currentKey {
            if ck == withKey {
                let defaults = NSUserDefaults.standardUserDefaults()
                if defaults.boolForKey(withKey) == false {
                    defaults.setObject(true, forKey: withKey)
                    var preferences = EasyTipView.globalPreferences()
                    EasyTipView.showAnimated(true,
                        forView: forView,
                        withinSuperview: withinSuperview,
                        text: self.tooltips[withKey]!.message,
                        preferences: preferences,
                        delegate: self,
                        dismissAfterDelay: 4)
                }
            }
        }
    }
    
}

extension ToolTipManager : EasyTipViewDelegate {
    func easyTipViewDidDismiss(tipView: EasyTipView) {
        if let nk = self.currentKey {
            self.currentKey = self.nextOfKey(nk)
        }
    }
}



