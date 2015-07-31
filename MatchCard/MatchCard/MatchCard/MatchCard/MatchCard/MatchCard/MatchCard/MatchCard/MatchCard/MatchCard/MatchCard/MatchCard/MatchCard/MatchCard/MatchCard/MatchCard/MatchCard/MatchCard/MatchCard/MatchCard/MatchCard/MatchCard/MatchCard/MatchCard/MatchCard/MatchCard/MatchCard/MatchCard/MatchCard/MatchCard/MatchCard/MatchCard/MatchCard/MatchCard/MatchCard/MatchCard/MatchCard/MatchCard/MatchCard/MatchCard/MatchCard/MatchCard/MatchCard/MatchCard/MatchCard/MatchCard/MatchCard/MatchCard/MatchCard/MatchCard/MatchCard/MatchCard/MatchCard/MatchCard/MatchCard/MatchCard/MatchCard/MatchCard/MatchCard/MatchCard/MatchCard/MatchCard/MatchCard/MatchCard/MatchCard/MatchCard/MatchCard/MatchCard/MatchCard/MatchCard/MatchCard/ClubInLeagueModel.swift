//
//  ClubInLeagueModel.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 13/07/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import Parse
import MapKit

/*
 Association between a club within a league. It looks up the club model for reference data such as map coordinates etc.
*/
class ClubInLeagueModel : PFObjectImaged, PFSubclassing, MKAnnotation {
    static func parseClassName() -> String {
        return "ClubInLeague"
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
    convenience init(_ club : ClubModel)
    {
        self.init()
        self.club = club
        var l = UILabel()
        l.text = club.name
        l.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(15))
        l.sizeToFit()
        l.clipsToBounds = true
        l.layer.cornerRadius = 5
        l.layer.borderWidth = 1
        l.layer.borderColor = UIColor.lightGrayColor().CGColor
        l.backgroundColor = UIColor.redColor().colorWithAlphaComponent(CGFloat(0.1))
        self.imageFile = l.capturedImage
    }
    
    @NSManaged var club : ClubModel?
    
    // MARK : Map Kit
    var title: String? {
        get {
            return "Selected"
        }
    }
    var subtitle: String? {
        get {
            return self.club!.address
        }
    }
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(self.club!.latitude), longitude: CLLocationDegrees(self.club!.longitude))
        }
    }
    var latitude : Float {
        get {
            return self.club!.latitude
        }
    }
    var longitude : Float {
        get {
            return self.club!.longitude
        }
    }
}