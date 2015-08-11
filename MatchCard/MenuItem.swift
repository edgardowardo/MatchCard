//
//  MenuItem.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

enum MenuItemType {
    case LoadSample, NewOpen, NewRoundRobin, New3Discipline, Clear, ClearScores, ResetTooltips
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
        return [
            MenuItem(title: "Load sample", image: UIImage(named: "icon-open-box"), type: .LoadSample),
            MenuItem(title: "New open league card", image: UIImage(named: "icon-open-box"), type: .NewOpen),
            MenuItem(title: "New round robin card", image: UIImage(named: "icon-open-box"), type: .NewRoundRobin),
            MenuItem(title: "New 3 discipline card", image: UIImage(named: "icon-open-box"), type: .New3Discipline),
            MenuItem(title: "Clear card", image: UIImage(named: "icon-trash"), type: .Clear),
            MenuItem(title: "Clear scores", image: UIImage(named: "icon-trash"), type: .ClearScores),
            MenuItem(title: "Reset tooltips", image: UIImage(named: "icon-tooltip"), type: .ResetTooltips)
        ]
    }
}