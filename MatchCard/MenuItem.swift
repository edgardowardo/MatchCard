//
//  MenuItem.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

enum MenuItemType {
    case Clear, ClearScores, ResetTooltips
}

@objc
class MenuItem {
    struct Notification {
        struct Identifier {
            static let Clear = "NotificationIdentifierForClear"
        }
    }
    let title: String
    let image: UIImage?
    let type: MenuItemType
    
    init(title: String, image: UIImage?, type: MenuItemType) {
        self.title = title
        self.image = image
        self.type = type
    }
    
    class func allItems() -> Array<MenuItem> {
        return [ MenuItem(title: "Clear card", image: UIImage(named: "icon-trash"), type: .Clear),
            MenuItem(title: "Clear scores", image: UIImage(named: "icon-trash"), type: .ClearScores),
            MenuItem(title: "Reset tooltips", image: UIImage(named: "icon-tooltip"), type: .ResetTooltips)
        ]
    }
}