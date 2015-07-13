//
//  ClubModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 03/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse

/*
    Data representation of a club which may be registered in several leagues. The club has a main venue represented by the coordinates.
*/
class ClubModel : PFObjectImaged, PFSubclassing {
    static func parseClassName() -> String {
        return "Club"
    }
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    override init () {
        super.init()
    }
    convenience init(latitude : Float, longitude : Float, name : String)
    {
        self.init()
        self.isAddme = false
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = ""
    }
    // MARK : Properties
    @NSManaged var latitude : Float
    @NSManaged var longitude : Float
    @NSManaged var address : String
}