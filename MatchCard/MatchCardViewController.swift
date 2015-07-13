//
//  MatchCardViewController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 05/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import MapKit

@objc
protocol MatchCardViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class MatchCardViewController : UIViewController {
    // MARK: Structured constants
    struct Notification {
        struct Identifier {
            static let ReloadData = "NotificationIdentifierOfReloadData"
        }
    }
    struct Map {
        struct Identifier {
            static let Club = "MapClubIdentifier"
        }
    }
    struct Tags {
        static let League = 1
        static let Division = 2
        static let Location = 3
        static let Away = 4
        static let Home = 5
    }
    // MARK: Properties
    @IBOutlet weak var containingView : UIView?
    @IBOutlet weak var matchCardCollectionView : UICollectionView?
    var delegate: MatchCardViewControllerDelegate?
    let mockLeagueTextField = UITextField(frame: CGRectZero)
    let mockDivTextField = UITextField(frame: CGRectZero)
    let mockLocTextField = UITextField(frame: CGRectZero)
    let mockLocPickerTextField = UITextField(frame: CGRectZero)
    let matchCardController = MatchCardController()
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let matchHeaderNib = MatchHeaderReusableView.Collection.Nib
        let scoreHeaderNib = ScoreHeaderReusableView.Collection.Nib
        let matchEntryNib = MatchEntryCell.Collection.Nib
        let matchPlayersNib = MatchPlayersReusableView.Collection.Nib
        let nibHeader = UINib(nibName: matchHeaderNib, bundle: nil)
        let nibScore = UINib(nibName: scoreHeaderNib, bundle: nil)
        let nibMatchEntry = UINib(nibName: matchEntryNib, bundle:nil)
        let nibPlayers = UINib(nibName: matchPlayersNib, bundle: nil)
        matchCardCollectionView?.delegate = matchCardController
        matchCardCollectionView?.dataSource = matchCardController
        matchCardCollectionView?.registerNib(nibHeader, forSupplementaryViewOfKind: MatchHeaderReusableView.Collection.Kind, withReuseIdentifier: MatchHeaderReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibScore, forSupplementaryViewOfKind: ScoreHeaderReusableView.Collection.Kind.Home, withReuseIdentifier: ScoreHeaderReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibScore, forSupplementaryViewOfKind: ScoreHeaderReusableView.Collection.Kind.Away, withReuseIdentifier: ScoreHeaderReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibMatchEntry, forCellWithReuseIdentifier: MatchEntryCell.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibPlayers, forSupplementaryViewOfKind: MatchPlayersReusableView.Collection.Kind.Home, withReuseIdentifier: MatchPlayersReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibPlayers, forSupplementaryViewOfKind: MatchPlayersReusableView.Collection.Kind.Away, withReuseIdentifier: MatchPlayersReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.setCollectionViewLayout(MatchCardStandardLayout(), animated: false)
        matchCardController.matchCollectionView = self.matchCardCollectionView
        if Common.showColorBounds() == false {
            matchCardCollectionView?.backgroundColor = UIColor.clearColor()
            containingView?.backgroundColor = UIColor.whiteColor()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_More:", name:MatchHeaderReusableView.Notification.Identifier.More, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowLeague:", name:MatchHeaderReusableView.Notification.Identifier.ShowLeagues, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowDivisions:", name:MatchHeaderReusableView.Notification.Identifier.ShowDivisions, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowLocations_Picker:", name:MatchHeaderReusableView.Notification.Identifier.ShowLocations_Picker, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowLocations_Map:", name:MatchHeaderReusableView.Notification.Identifier.ShowLocations_Map, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ReloadData:", name: Notification.Identifier.ReloadData, object: nil)
        // Pickers - League
        let pickerLeague = UIPickerView()
        pickerLeague.delegate = self
        pickerLeague.dataSource = self
        pickerLeague.tag = Tags.League
        self.view.addSubview(self.mockLeagueTextField)
        self.mockLeagueTextField.inputView = pickerLeague
        // Pickers - Division
        let pickerDivision = UIPickerView()
        pickerDivision.delegate = self
        pickerDivision.dataSource = self
        pickerDivision.tag = Tags.Division
        self.view.addSubview(self.mockDivTextField)
        self.mockDivTextField.inputView = pickerDivision
        // Map - Location
        let map = MKMapView(frame: CGRectMake(0, 0, 320, 320))
        map.delegate = self
        self.view.addSubview(self.mockLocTextField)
        self.mockLocTextField.inputView = map
        // Picker - Location
        let pickerLocation = UIPickerView()
        pickerLocation.delegate = self
        pickerLocation.dataSource = self
        pickerLocation.tag = Tags.Location
        self.view.addSubview(self.mockLocPickerTextField)
        self.mockLocPickerTextField.inputView = pickerLocation
        // keyboard toolbar
        var doneToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: Selector("doneTap"))
        doneToolbar.setItems([flexibleSpace, doneButton], animated: true)
        self.mockLeagueTextField.inputAccessoryView = doneToolbar
        self.mockDivTextField.inputAccessoryView = doneToolbar
        self.mockLocTextField.inputAccessoryView = doneToolbar
        self.mockLocPickerTextField.inputAccessoryView = doneToolbar
    }
    func doneTap() {
        self.mockLeagueTextField.resignFirstResponder()
        self.mockDivTextField.resignFirstResponder()
        self.mockLocTextField.resignFirstResponder()
        self.mockLocPickerTextField.resignFirstResponder()
    }
    @objc private func methodOfReceivedNotification_More(notification: NSNotification){
        delegate?.toggleLeftPanel?()
    }
    @objc private func methodOfReceivedNotification_ShowLeague(notification : NSNotification){
        self.mockLeagueTextField.becomeFirstResponder()
    }
    @objc private func methodOfReceivedNotification_ShowDivisions(notification : NSNotification){
        self.mockDivTextField.becomeFirstResponder()
        var p = self.mockDivTextField.inputView as! UIPickerView
        p.reloadAllComponents()
    }
    @objc private func methodOfReceivedNotification_ShowLocations_Picker(notification : NSNotification){
        self.mockLocPickerTextField.becomeFirstResponder()
        var p = self.mockLocPickerTextField.inputView as! UIPickerView
        p.reloadAllComponents()
        if let homeClub = DataManager.sharedInstance.matchCard.homeClub {
        }
    }
    @objc private func methodOfReceivedNotification_ShowLocations_Map(notification : NSNotification){
        var map = self.mockLocTextField.inputView as! MKMapView
        let clubs = DataManager.sharedInstance.matchCard.league!.clubs
        let minLongitude = clubs.reduce(Float.infinity, combine: { min($0 , $1.longitude) })
        let maxLongitude = clubs.reduce(-Float.infinity, combine: { max($0 , $1.longitude) })
        let minLatitude = clubs.reduce(Float.infinity, combine: { min($0 , $1.latitude) })
        let maxLatitude = clubs.reduce(-Float.infinity, combine: { max($0 , $1.latitude) })
        let centerLat = (maxLatitude + minLatitude) / 2
        let centerLon = (maxLongitude + minLongitude) / 2
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(centerLat), longitude: CLLocationDegrees(centerLon))
        let deltaLat = abs(maxLatitude - minLatitude) * 1.3
        let deltaLon = abs(maxLongitude - minLongitude) * 1.3
        let span = MKCoordinateSpanMake(CLLocationDegrees(deltaLat), CLLocationDegrees(deltaLon))
        let region = MKCoordinateRegionMake(center, span)
        self.mockLocTextField.becomeFirstResponder()
        map.setRegion(region, animated: false)
        map.removeAnnotations(map.annotations)
        map.addAnnotations(clubs)
        var homeClub = DataManager.sharedInstance.matchCard.homeClub
        if  homeClub != nil {
            map.selectAnnotation(homeClub, animated: true)
        } else {
            // FIXME: select the annotation nearest current location            
            map.selectAnnotation(map.annotations.first as! MKAnnotation, animated: true)
        }
    }
    @objc private func methodOfReceivedNotification_ReloadData(notifcation: NSNotification){
        matchCardCollectionView?.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MatchCardViewController: SidePanelViewControllerDelegate {
    func itemSelected(item: MenuItem) {
        switch item.type {
        case .Clear :
            DataManager.sharedInstance.clear()
            matchCardCollectionView?.reloadData()
        case .ClearScores :
            DataManager.sharedInstance.clearScores()
            matchCardCollectionView?.reloadData()
        }
        delegate?.collapseSidePanels?()
    }
}

extension MatchCardViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        DataManager.sharedInstance.matchCard.homeClub = view.annotation as? ClubInLeagueModel
        NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.FadeLabel, object: view)
    }
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(ClubInLeagueModel) {
            let c = annotation as! ClubInLeagueModel
            var a = mapView.dequeueReusableAnnotationViewWithIdentifier(Map.Identifier.Club)
            if a == nil {
                a = MKAnnotationView(annotation: annotation, reuseIdentifier: Map.Identifier.Club)
                a.tag = Tags.Location
            } else {
                a.annotation = annotation
            }
            a.canShowCallout = true
            a.image = c.imageFile
            return a
        }
        return nil
    }
}

extension MatchCardViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case Tags.League :
            return DataManager.sharedInstance.allLeagues.count
        case Tags.Division :
            return DataManager.sharedInstance.matchCard.league!.divisions
        case Tags.Location :
            return DataManager.sharedInstance.matchCard.league!.clubs.count
        default :
            return 0
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch pickerView.tag {
        case Tags.League :
            return DataManager.sharedInstance.allLeagues[row].name
        case Tags.Division :
            return "\(row+1)"
        case Tags.Location :
            return DataManager.sharedInstance.matchCard.league!.clubs[row].club!.name
        default :
            return "unknown"
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case Tags.League :
            DataManager.sharedInstance.matchCard.league = DataManager.sharedInstance.allLeagues[row]
            DataManager.sharedInstance.matchCard.homeClub = nil
            DataManager.sharedInstance.matchCard.division = 0
        case Tags.Division :
            DataManager.sharedInstance.matchCard.division = row + 1
        case Tags.Location :
            DataManager.sharedInstance.matchCard.homeClub = DataManager.sharedInstance.matchCard.league!.clubs[row]
        default :
            assertionFailure("picker tag unknown")
        }
        NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.FadeLabel, object: pickerView)
    }
    // FIXME: Seem attributed string seem to not work...
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
//        let ats = NSMutableAttributedString(string: title, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(50)) ])
//        return ats
//    }
    
}