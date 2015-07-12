//
//  ClubModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 03/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse
import MapKit

class ClubModel : PFObjectImaged, PFSubclassing, MKAnnotation {
    // MARK : 
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
        var l = UILabel()
        l.text = name
        l.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(15))
        l.sizeToFit()
        l.clipsToBounds = true
        l.layer.cornerRadius = 5
        l.layer.borderWidth = 1
        l.layer.borderColor = UIColor.lightGrayColor().CGColor
        l.backgroundColor = UIColor.redColor().colorWithAlphaComponent(CGFloat(0.1))
        self.imageFile = l.imageFile
    }
    // MARK : Properties
    @NSManaged var latitude : Float
    @NSManaged var longitude : Float
    @NSManaged var address : String
    
    // MARK : Map Kit
    var title: String? {
        get {
            return "Selected"
        }
    }
    var subtitle: String? {
        get {
            return address
        }
    }
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
        }
    }
}