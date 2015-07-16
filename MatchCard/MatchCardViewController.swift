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

enum LayoutType {
    case Standard, Edit, Players, Matrix
}

@objc
protocol MatchCardViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class MatchCardViewController : UIViewController {
    //
    // MARK: Structured constants
    //
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
        static let Nothing = 0
        static let League = 1
        static let Division = 2
        static let Location = 3
        static let AwayTeam = 4
        static let HomeTeam_AllTeams = 5
        static let HomeTeam_Filter = 6
    }
    //
    // MARK: Properties
    //
    @IBOutlet weak var containingView : UIView?
    @IBOutlet weak var matchCardCollectionView : UICollectionView?
    var delegate: MatchCardViewControllerDelegate?
    let mockLeagueTextField = UITextField(frame: CGRectZero)
    let mockDivTextField = UITextField(frame: CGRectZero)
    let mockLocTextField = UITextField(frame: CGRectZero)
    let mockLocPickerTextField = UITextField(frame: CGRectZero)
    let mockTeamTextField = UITextField(frame: CGRectZero)
    let matchCardController = MatchCardController()
    //
    // MARK: View lifecycle and helpers
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibHeader = UINib(nibName: MatchHeaderReusableView.Collection.Nib, bundle: nil)
        let nibScore = UINib(nibName: ScoreHeaderReusableView.Collection.Nib, bundle: nil)
        let nibMatchEntry = UINib(nibName: MatchEntryCell.Collection.Nib, bundle:nil)
        let nibPlayers = UINib(nibName: MatchPlayersReusableView.Collection.Nib, bundle: nil)
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
        // Notifications Received
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_More:", name:MatchHeaderReusableView.Notification.Identifier.More, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowLeague:", name:MatchHeaderReusableView.Notification.Identifier.ShowLeagues, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowDivisions:", name:MatchHeaderReusableView.Notification.Identifier.ShowDivisions, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowLocations_Picker:", name:MatchHeaderReusableView.Notification.Identifier.ShowLocations_Picker, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowLocations_Map:", name:MatchHeaderReusableView.Notification.Identifier.ShowLocations_Map, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowTeams:", name: ScoreHeaderReusableView.Notification.Identifier.ShowTeams, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowPlayers:", name:PlayerViewCell.Notification.Identifier.SelectPlayer, object: nil)        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ReloadData:", name: Notification.Identifier.ReloadData, object: nil)
        // Assemble inputViews
        // inputView is MapView for Location
        let map = MKMapView(frame: CGRectMake(0, 0, 320, 320))
        map.delegate = self
        self.view.addSubview(self.mockLocTextField)
        self.mockLocTextField.inputView = map
        // inputView is picker view for the following fields:
        addPickerAndDoneToolBar(toTextField : mockLeagueTextField, withTag: Tags.League)
        addPickerAndDoneToolBar(toTextField : mockDivTextField, withTag: Tags.Division )
        addPickerAndDoneToolBar(toTextField : mockLocPickerTextField, withTag: Tags.Location)
        addPickerAndDoneToolBar(toTextField : mockTeamTextField, withTag: Tags.Nothing)
//        doneButton.action = Selector("doneTap")
    }
    func addPickerAndDoneToolBar(#toTextField : UITextField, withTag : Int) {
        let p = UIPickerView()
        p.delegate = self
        p.dataSource = self
        p.tag = withTag
        self.view.addSubview(toTextField)
        toTextField.inputView = p
        
        var doneToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: Selector("doneTappedGeneric"))
        doneToolbar.setItems([flexibleSpace, doneButton], animated: true)
        toTextField.inputAccessoryView = doneToolbar
    }
    func doneTappedGeneric() {
        self.mockLeagueTextField.resignFirstResponder()
        self.mockDivTextField.resignFirstResponder()
        self.mockLocTextField.resignFirstResponder()
        self.mockLocPickerTextField.resignFirstResponder()
        self.mockTeamTextField.resignFirstResponder()
        if let homeTeam = DataManager.sharedInstance.matchCard.homeTeamBag.team {
            if let awayTeam = DataManager.sharedInstance.matchCard.awayTeamBag.team {
                if homeTeam.name == awayTeam.name {
                    UIAlertView(title: "Warning", message: "You selected the same team as home and away", delegate: self, cancelButtonTitle: "OK").show()
                }
            }
        }
    }
    func selectElement<T:Equatable>(elementy : T?, fromArray : [T], inTextFieldWithPicker textfield : UITextField) {
        textfield.becomeFirstResponder()
        let p = textfield.inputView as! UIPickerView
        p.reloadAllComponents()
        if let l = elementy {
            let index : Int? = find(fromArray, l)
            if let i = index {
                p.selectRow(i, inComponent: 0, animated: true)
            }
        }
    }
    
    //
    // Notification handlers
    //
    @objc private func methodOfReceivedNotification_More(notification: NSNotification){
        delegate?.toggleLeftPanel?()
    }
    @objc private func methodOfReceivedNotification_ShowLeague(notification : NSNotification){
        selectElement(DataManager.sharedInstance.matchCard.league,
            fromArray: DataManager.sharedInstance.allLeagues,
            inTextFieldWithPicker: self.mockLeagueTextField)
    }
    @objc private func methodOfReceivedNotification_ShowDivisions(notification : NSNotification){
        var div : Int?
        if DataManager.sharedInstance.matchCard.division > 0 {
            div = DataManager.sharedInstance.matchCard.division
        }
        let divCount = DataManager.sharedInstance.matchCard.league?.divisions
        var divisions = [Int]()
        for var i = 0; i < divCount; i++  {
            divisions.append(i+1)
        }
        selectElement(div, fromArray: divisions, inTextFieldWithPicker: self.mockDivTextField)
    }
    @objc private func methodOfReceivedNotification_ShowLocations_Picker(notification : NSNotification){
        selectElement(DataManager.sharedInstance.matchCard.homeClub,
            fromArray: DataManager.sharedInstance.matchCard.league!.clubs,
            inTextFieldWithPicker: self.mockLocPickerTextField)
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
            // TODO: select the annotation nearest current location
            map.selectAnnotation(map.annotations.first as! MKAnnotation, animated: true)
        }
    }
    @objc private func methodOfReceivedNotification_ShowTeams(notification: NSNotification){
        let kind = notification.object as! String
        var p = self.mockTeamTextField.inputView as! UIPickerView
        var team : TeamInClubModel? = nil
        var teams : [TeamInClubModel] = DataManager.sharedInstance.matchCard.teams
        // Differentiate between the single picker view and double picker view
        if kind == ScoreHeaderReusableView.Collection.Kind.Away {
            p.tag = Tags.AwayTeam
            team = DataManager.sharedInstance.matchCard.awayTeamBag.team
        } else {
            team = DataManager.sharedInstance.matchCard.homeTeamBag.team
            if self.hasHomeClub() {
                p.tag = Tags.HomeTeam_Filter
                teams = DataManager.sharedInstance.matchCard.homeClub!.club!.teams
            } else {
                p.tag = Tags.HomeTeam_AllTeams
            }
        }
        selectElement(team,
            fromArray: teams,
            inTextFieldWithPicker: self.mockTeamTextField)
    }
    @objc private func methodOfReceivedNotification_ShowPlayers(notification: NSNotification){
        //        let kind = notification.object as! String
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
    func hasHomeClub() -> Bool {
        if let h = DataManager.sharedInstance.matchCard.homeClub {
            return true
        }
        return false
    }
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
        case Tags.HomeTeam_AllTeams :
            return DataManager.sharedInstance.matchCard.teams.count
        case Tags.HomeTeam_Filter :
            return DataManager.sharedInstance.matchCard.homeClub!.club!.teams.count
        case Tags.AwayTeam :
            return DataManager.sharedInstance.matchCard.teams.count
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
        case Tags.HomeTeam_AllTeams :
            return DataManager.sharedInstance.matchCard.teams[row].name
        case Tags.HomeTeam_Filter :
                return DataManager.sharedInstance.matchCard.homeClub!.club!.teams[row].name
        case Tags.AwayTeam :
            return DataManager.sharedInstance.matchCard.teams[row].name
        default :
            return "unknown"
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case Tags.League :
            DataManager.sharedInstance.matchCard.league = DataManager.sharedInstance.allLeagues[row]
            // clear lookups
            DataManager.sharedInstance.matchCard.clearLookups()
        case Tags.Division :
            DataManager.sharedInstance.matchCard.division = row + 1
        case Tags.Location :
            DataManager.sharedInstance.matchCard.homeClub = DataManager.sharedInstance.matchCard.league!.clubs[row]
        case Tags.HomeTeam_AllTeams :
            let teamInClub = DataManager.sharedInstance.matchCard.teams[row]
            DataManager.sharedInstance.matchCard.homeTeamBag.team = teamInClub
            DataManager.sharedInstance.matchCard.homeClub = teamInClub.club
        case Tags.HomeTeam_Filter :
            DataManager.sharedInstance.matchCard.homeTeamBag.team = DataManager.sharedInstance.matchCard.homeClub!.club!.teams[row]
        case Tags.AwayTeam :
            DataManager.sharedInstance.matchCard.awayTeamBag.team = DataManager.sharedInstance.matchCard.teams[row]
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

extension MatchCardViewController : UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    }
}
