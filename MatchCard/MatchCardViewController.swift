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
    case Standard, Edit, HomePlayers, AwayPlayers, Matrix, MatrixHomePlayers, MatrixAwayPlayers
}

@objc
protocol MatchCardViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class MatchCardViewController : UIViewController {

    // MARK:- Structured constants -

    struct Notification {
        struct Identifier {
            static let ReloadData = "NotificationIdentifierOf_ReloadData"
            static let SetLayout = "NotificationIdentifierOf_SetLayout"
            static let RemoveRegisteredPlayer = "NotificationIdentifierOf_RemoveRegisteredPlayer"
        }
    }
    struct Map {
        struct Identifier {
            static let Club = "MapClubIdentifier"
        }
    }
    // These tags are used to identify which textfield owns the picker view
    struct Tags {
        static let Nothing = 0
        static let GameEntry  = 1
        static let League = 2
        static let Division = 3
        static let Location = 4
        static let AwayTeam = 5
        static let HomeTeam_AllTeams = 6
        static let HomeTeam_Filter = 7
        static let AlertNoLeague = 8
        static let AlertNoAwayTeam = 9
        static let AlertNoHomeTeam = 10
        static let AlertNoPosition = 11
    }
    struct Separator {
        static let Kind = "UICollectionElementKindSeparator"
        static let ReuseIdentifier = "SeparatorReusableView"
    }
    
    // MARK:- Properties -

    @IBOutlet weak var containingView : UIView?
    @IBOutlet weak var matchCardCollectionView : UICollectionView?
    var delegate: MatchCardViewControllerDelegate?
    let mockGameEntryTextField = UITextField(frame: CGRectZero)
    let mockLeagueTextField = UITextField(frame: CGRectZero)
    let mockDivTextField = UITextField(frame: CGRectZero)
    let mockLocTextField = UITextField(frame: CGRectZero)
    let mockLocPickerTextField = UITextField(frame: CGRectZero)
    let mockTeamTextField = UITextField(frame: CGRectZero)
    let mockPlayerTextField = UITextField(frame: CGRectZero)
    var selectedPlayerPositionCell : PlayerViewCell?
    lazy var playersInputController = PlayersInputController()
    var layouts : [LayoutType : UICollectionViewLayout] = [.Standard : MatchCardStandardLayout(), .Edit : GameEntryEditLayout(), .HomePlayers : HomePlayersLayout(), .AwayPlayers : AwayPlayersLayout(), .Matrix : MatrixLayout()]
    var layout : LayoutType = .Standard {
        didSet {
            self.matchCardCollectionView?.setCollectionViewLayout(self.layouts[self.layout]!, animated: true)
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.SetLayout, object: self)
            switch layout {
            case .AwayPlayers :
                fallthrough
            case .HomePlayers :
                self.matchCardCollectionView?.scrollEnabled = false
                self.matchCardCollectionView?.scrollsToTop = false
            case .Edit :
                self.matchCardCollectionView?.scrollsToTop = false
            case .Standard :
                fallthrough
            case .Matrix :
                fallthrough
            default :
                self.matchCardCollectionView?.scrollEnabled = true
                self.matchCardCollectionView?.scrollsToTop = true
            }
//            println("contentOffset.0 = \(self.matchCardCollectionView?.contentOffset), contentInset=\(self.matchCardCollectionView!.contentInset.bottom)")
        }
    }

    // MARK:- View lifecycle and helpers -

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibHeader = UINib(nibName: MatchHeaderReusableView.Collection.Nib, bundle: nil)
        let nibScore = UINib(nibName: ScoreHeaderReusableView.Collection.Nib, bundle: nil)
        let nibGameEntry = UINib(nibName: GameEntryCell.Collection.Nib, bundle:nil)
        let nibEntryAnnoteHome = UINib(nibName: EntryAnnotationReusableView.Collection.Home.Nib, bundle: nil)
        let nibEntryAnnoteAway = UINib(nibName: EntryAnnotationReusableView.Collection.Away.Nib, bundle: nil)
        let nibPlayers = UINib(nibName: MatchPlayersReusableView.Collection.Nib, bundle: nil)
        let nibTotals = UINib(nibName: GameTotalsReusableView.Collection.Nib, bundle: nil)
        let nibCorner = UINib(nibName: MatrixCornerReusableView.Collection.Nib, bundle: nil)
        matchCardCollectionView?.scrollsToTop = true
        matchCardCollectionView?.delegate = self
        matchCardCollectionView?.dataSource = self
        matchCardCollectionView?.registerNib(nibHeader, forSupplementaryViewOfKind: MatchHeaderReusableView.Collection.Kind, withReuseIdentifier: MatchHeaderReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibScore, forSupplementaryViewOfKind: ScoreHeaderReusableView.Collection.Kind.Home, withReuseIdentifier: ScoreHeaderReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibScore, forSupplementaryViewOfKind: ScoreHeaderReusableView.Collection.Kind.Away, withReuseIdentifier: ScoreHeaderReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibGameEntry, forCellWithReuseIdentifier: GameEntryCell.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibEntryAnnoteHome, forSupplementaryViewOfKind: EntryAnnotationReusableView.Collection.Home.Kind, withReuseIdentifier: EntryAnnotationReusableView.Collection.Home.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibEntryAnnoteAway, forSupplementaryViewOfKind: EntryAnnotationReusableView.Collection.Away.Kind, withReuseIdentifier: EntryAnnotationReusableView.Collection.Away.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibPlayers, forSupplementaryViewOfKind: MatchPlayersReusableView.Collection.Kind.Home, withReuseIdentifier: MatchPlayersReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibPlayers, forSupplementaryViewOfKind: MatchPlayersReusableView.Collection.Kind.Away, withReuseIdentifier: MatchPlayersReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibTotals, forSupplementaryViewOfKind: GameTotalsReusableView.Collection.Kind, withReuseIdentifier: GameTotalsReusableView.Collection.ReuseIdentifier)
        matchCardCollectionView?.registerClass(UICollectionReusableView.self , forSupplementaryViewOfKind: Separator.Kind, withReuseIdentifier: Separator.ReuseIdentifier)
        matchCardCollectionView?.registerNib(nibCorner, forSupplementaryViewOfKind: MatrixCornerReusableView.Collection.Kind, withReuseIdentifier: MatrixCornerReusableView.Collection.ReuseIdentifier)        
        matchCardCollectionView?.setCollectionViewLayout(MatchCardStandardLayout(), animated: false)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ShowRegisteredPlayers:", name:PlayersInputController.Notification.Identifier.ShowRegisteredPlayers, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ReloadData:", name: Notification.Identifier.ReloadData, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_RemoveRegisteredPlayer:", name: Notification.Identifier.RemoveRegisteredPlayer, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification_ToggleRoundrobin:", name: ScoreHeaderReusableView.Notification.Identifier.ToggleRoundrobin, object: nil)
        
        // Assemble inputViews
        // inputView is MapView for Location
        let map = MKMapView(frame: CGRectMake(0, 0, 320, 320))
        map.delegate = self
        self.view.addSubview(self.mockLocTextField)
        self.mockLocTextField.inputView = map
        addDoneToolbar(toTextField: self.mockLocTextField)
        // inputView is picker view for the following fields:
        addPickerAndDoneToolBar(toTextField: mockLeagueTextField, withTag: Tags.League)
        addPickerAndDoneToolBar(toTextField: mockDivTextField, withTag: Tags.Division )
        addPickerAndDoneToolBar(toTextField: mockLocPickerTextField, withTag: Tags.Location)
        addPickerAndDoneToolBar(toTextField: mockTeamTextField, withTag: Tags.Nothing)
        addPickerAndDoneToolBar(toTextField: mockGameEntryTextField, withTag: Tags.GameEntry, andSelector : "doneTappedGameEntry")
        //
        // Players Input View
        //
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(70, 80)
        let playersInputView = UICollectionView(frame: CGRectMake(0, 0, PlayersInputController.Collection.Width, PlayersInputController.Collection.Height), collectionViewLayout: layout)
        let nibPlayer = UINib(nibName: PlayerViewCell.Collection.Nib, bundle: nil)
        playersInputView.registerNib(nibPlayer, forCellWithReuseIdentifier: PlayerViewCell.Collection.ReuseIdentifier)
        playersInputView.backgroundColor = UIColor.lightGrayColor()
        playersInputView.delaysContentTouches = false
        self.playersInputController.delegate = self
        self.view.addSubview(mockPlayerTextField)
        mockPlayerTextField.inputView = playersInputView
        addDoneToolbar(toTextField: mockPlayerTextField, withSelector: "doneTappedPlayer")
        //
        // Tool tip
        //
        var preferences = EasyTipView.Preferences()
        preferences.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        preferences.bubbleColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        preferences.textColor = UIColor.whiteColor()
        preferences.textAlignment = NSTextAlignment.Justified
        preferences.arrowPosition = EasyTipView.ArrowPosition.Top
        EasyTipView.setGlobalPreferences(preferences)
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Helpers so as not to overlap the match entry cell against the keyboard
    
    func keyboardDidShow(notification: NSNotification) {
        if self.layout == .Edit {
            if let keyboardRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                if let activeCell = self.matchCardCollectionView?.selectedCell() {
                    let kbRect = self.matchCardCollectionView?.convertRect(keyboardRect, fromView: nil)
                    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
                    let contentInsets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: kbRect!.size.height, right: 0)
                    self.matchCardCollectionView?.contentInset = contentInsets
                    self.matchCardCollectionView?.scrollRectToVisible(activeCell.frame, animated: true)
                    self.matchCardCollectionView?.scrollEnabled = false
                }
            }
        }
    }
    func keyboardWillBeHidden(notification: NSNotification) {
        if self.layout == .Standard {
            let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
            let contentInsets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
            self.matchCardCollectionView!.contentInset = contentInsets
            self.matchCardCollectionView?.scrollEnabled = true
        }
    }
    
    // MARK: Picker helpers
    
    func addPickerAndDoneToolBar(#toTextField : UITextField, withTag : Int, andSelector selector: String = "doneTappedGeneric") {
        let p = UIPickerView()
        p.delegate = self
        p.dataSource = self
        p.tag = withTag
        self.view.addSubview(toTextField)
        toTextField.inputView = p
        addDoneToolbar(toTextField: toTextField, withSelector: selector)
    }
    func addDoneToolbar(#toTextField : UITextField, withSelector selector: String = "doneTappedGeneric" ) {
        var doneToolbar = UIToolbar(frame: CGRectMake(0, 0, UIToolbar.Size.Width, UIToolbar.Size.Height))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: Selector(selector))
        doneToolbar.setItems([flexibleSpace, doneButton], animated: true)
        toTextField.inputAccessoryView = doneToolbar
    }
    func doneTappedPlayer() {
        self.mockPlayerTextField.resignFirstResponder()
        self.layout = .Standard
        NSNotificationCenter.defaultCenter().postNotificationName(MatchPlayersReusableView.Notification.Identifier.Deselect, object:nil)
    }
    func doneTappedGeneric() {
        self.mockLeagueTextField.resignFirstResponder()
        self.mockDivTextField.resignFirstResponder()
        self.mockLocTextField.resignFirstResponder()
        self.mockLocPickerTextField.resignFirstResponder()
        self.mockTeamTextField.resignFirstResponder()
        if let homeTeam = DataManager.sharedInstance.matchCard.homeTeamBag!.team {
            if let awayTeam = DataManager.sharedInstance.matchCard.awayTeamBag.team {
                if homeTeam.name == awayTeam.name {
                    UIAlertView(title: "Warning", message: "You selected the same team as home and away", delegate: self, cancelButtonTitle: "OK").show()
                }
            }
        }
    }
    func doneTappedGameEntry() {
        if self.layout == .Edit {
            // TO STANDARD MODE
            self.layout = .Standard
            mockGameEntryTextField.resignFirstResponder()
            let cell = matchCardCollectionView!.selectedCell() as! GameEntryCell
            cell.layer.borderColor = UIColor.clearColor().CGColor
            cell.setFontSize(.Standard)
            cell.layer.borderColor = UIColor.clearColor().CGColor
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
    @objc private func methodOfReceivedNotification_ToggleRoundrobin(notification: NSNotification){
        // Toggle the layout indeed!
        if self.layout == .Standard {
            self.layout = .Matrix
        } else if self.layout == .Matrix {
            self.layout = .Standard
        }
        
        // Scroll up to to hide upper header and reclaim space
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let headerHeight = MatchHeaderReusableView.Collection.Cell.Size.height
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let point = CGPointMake(0, (headerHeight - statusBarHeight*2 ))
        Common.delay(0.4, closure: { () -> () in
            self.matchCardCollectionView?.scrollRectToVisible(CGRectMake(0, screenHeight + headerHeight - statusBarHeight*2, 1, 1), animated: true)
            ContainerViewController.isPannable = false
            self.matchCardCollectionView?.reloadData()
        })
    }
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
            fromArray: DataManager.sharedInstance.matchCard.league!.clubs!,
            inTextFieldWithPicker: self.mockLocPickerTextField)
    }
    @objc private func methodOfReceivedNotification_ShowLocations_Map(notification : NSNotification){
        var map = self.mockLocTextField.inputView as! MKMapView
        let clubs = DataManager.sharedInstance.matchCard.league!.clubs!
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
            team = DataManager.sharedInstance.matchCard.homeTeamBag!.team
            if self.hasHomeClub() {
                p.tag = Tags.HomeTeam_Filter
                teams = DataManager.sharedInstance.matchCard.homeClub!.club!.teams!
            } else {
                p.tag = Tags.HomeTeam_AllTeams
            }
        }
        self.selectElement(team,
            fromArray: teams,
            inTextFieldWithPicker: self.mockTeamTextField)        
    }
    @objc private func methodOfReceivedNotification_ShowRegisteredPlayers(notification: NSNotification){
        checkLeagueBeforeDoing { () -> () in
            let cell = notification.object as! PlayerViewCell
            if cell.elementKind == MatchPlayersReusableView.Collection.Kind.Away {
                if let awayTeam = DataManager.sharedInstance.matchCard.awayTeamBag.team {
                    self.layout = .AwayPlayers
                } else {
                    var a = UIAlertView(title: "Away team is unknown", message: "Set the away team?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                    a.tag = Tags.AlertNoAwayTeam
                    a.show()
                    return
                }
            } else if cell.elementKind == MatchPlayersReusableView.Collection.Kind.Home {
                if let homeTeam = DataManager.sharedInstance.matchCard.homeTeamBag!.team {
                    self.layout = .HomePlayers
                } else {
                    var a = UIAlertView(title: "Home team is unknown", message: "Set the home team?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                    a.tag = Tags.AlertNoHomeTeam
                    a.show()
                    return
                }
            }
            cell.updateButton()
            
            let cv = self.mockPlayerTextField.inputView as! UICollectionView
            cv.delegate = self.playersInputController
            cv.dataSource = self.playersInputController
            cv.reloadData()
            self.playersInputController.elementKind = cell.elementKind
            self.mockPlayerTextField.becomeFirstResponder()
            self.selectedPlayerPositionCell = cell
        }
    }
    @objc private func methodOfReceivedNotification_ReloadData(notifcation: NSNotification){
        matchCardCollectionView?.reloadData()
    }
    @objc private func methodOfReceivedNotification_RemoveRegisteredPlayer(notification: NSNotification){
        let cell = notification.object as! PlayerViewCell
        let cv = self.mockPlayerTextField.inputView as! UICollectionView
        self.deleteCellfromCollectionView(cv, withItemAtIndexPath: cell.indexPath!)
    }
    func deleteCellfromCollectionView( collectionView: UICollectionView, withItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! PlayerViewCell
        if (self.playersInputController.elementKind == MatchPlayersReusableView.Collection.Kind.Away) {
            DataManager.sharedInstance.matchCard.awayTeamBag.team!.exclusion.append(cell.player!)
            collectionView.deleteItemsAtIndexPaths([indexPath])
        } else {
            DataManager.sharedInstance.matchCard.homeTeamBag!.team!.exclusion.append(cell.player!)
            collectionView.deleteItemsAtIndexPaths([indexPath])
        }
    }
    
    func checkLeagueBeforeDoing( function :  () -> () ) {
        if let league = DataManager.sharedInstance.matchCard.league {
            function()
        } else {
            var a = UIAlertView(title: "League is unknown", message: "Set the league?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            a.tag = Tags.AlertNoLeague
            a.show()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK:- SidePanel delegates -

extension MatchCardViewController: SidePanelViewControllerDelegate {
    func itemSelected(item: MenuItem) {
        var reload = true
        switch item.type {
        case .LoadSample :
            let matchCard = DataManager.sharedInstance.matchCard
            switch matchCard.cardType! {
            case .Open:
                DataManager.sharedInstance.loadMatchCard_Open(matchCard)
            case .RoundRobin:
                DataManager.sharedInstance.loadMatchCard_RoundRobin(matchCard)
            case .ThreeDiscipline:
                DataManager.sharedInstance.loadMatchCard_3Discipline(matchCard)
            default:
                assertionFailure("unknown card type to load!")
            }
        case .NewOpen :
            DataManager.sharedInstance.matchCard = DataManager.sharedInstance.newMatchCard_Open()
        case .NewRoundRobin :
            DataManager.sharedInstance.matchCard = DataManager.sharedInstance.newMatchCard_RoundRobin()            
        case .New3Discipline :
            DataManager.sharedInstance.matchCard = DataManager.sharedInstance.newMatchCard_3Discipline()
        case .Clear :
            DataManager.sharedInstance.clear()
        case .ClearScores :
            DataManager.sharedInstance.clearScores()
        case .ResetTooltips :
            ToolTipManager.sharedInstance.resetTooltips()
            UIAlertView(title: "Tooltips", message: "Tool tips are now reset. Close and open the app to show.", delegate: self, cancelButtonTitle: "OK").show()
            reload = false
        }
        if reload {
            matchCardCollectionView?.reloadData()
            NSNotificationCenter.defaultCenter().postNotificationName(MatchPlayersReusableView.Notification.Identifier.Reload, object: nil)
        }
        delegate?.collapseSidePanels?()
    }
}


// MARK:- MKMapView delegates -

extension MatchCardViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        DataManager.sharedInstance.matchCard.homeClub = view.annotation as? ClubInLeagueModel
        NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.FadeLabel, object: view)
        NSNotificationCenter.defaultCenter().postNotificationName(MatchPlayersReusableView.Notification.Identifier.Reload, object: nil)
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


// MARK:- UIPickerView delegates -

extension MatchCardViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func hasHomeClub() -> Bool {
        if let h = DataManager.sharedInstance.matchCard.homeClub {
            return true
        }
        return false
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case Tags.GameEntry :
            return 2
        default :
            return 1
        }
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case Tags.GameEntry :
            return 31 + 3
        case Tags.League :
            return DataManager.sharedInstance.allLeagues.count
        case Tags.Division :
            return DataManager.sharedInstance.matchCard.league!.divisions
        case Tags.Location :
            return DataManager.sharedInstance.matchCard.league!.clubs!.count
        case Tags.HomeTeam_AllTeams :
            return DataManager.sharedInstance.matchCard.teams.count
        case Tags.HomeTeam_Filter :
            return DataManager.sharedInstance.matchCard.homeClub!.club!.teams!.count
        case Tags.AwayTeam :
            return DataManager.sharedInstance.matchCard.teams.count
        default :
            return 0
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch pickerView.tag {
        case Tags.GameEntry :
            switch row {
            case GameEntryModel.Incident.Disqualified.rawValue:
                return GameEntryModel.Incident.longName(.Disqualified)
            case GameEntryModel.Incident.Retired.rawValue:
                return GameEntryModel.Incident.longName(.Retired)
            case GameEntryModel.Incident.Walkover.rawValue:
                return GameEntryModel.Incident.longName(.Walkover)
            default :
                return "\(row)"
            }
        case Tags.League :
            return DataManager.sharedInstance.allLeagues[row].name
        case Tags.Division :
            return "\(row+1)"
        case Tags.Location :
            return DataManager.sharedInstance.matchCard.league!.clubs![row].club!.name
        case Tags.HomeTeam_AllTeams :
            return DataManager.sharedInstance.matchCard.teams[row].name
        case Tags.HomeTeam_Filter :
                return DataManager.sharedInstance.matchCard.homeClub!.club!.teams![row].name
        case Tags.AwayTeam :
            return DataManager.sharedInstance.matchCard.teams[row].name
        default :
            return "unknown"
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case Tags.GameEntry :
            let cell = matchCardCollectionView!.selectedCell() as! GameEntryCell
            let data = cell.data!
            if component == 0 {
                switch row {
                case GameEntryModel.Incident.Disqualified.rawValue:
                    data.homeIncident = .Disqualified
                case GameEntryModel.Incident.Retired.rawValue:
                    data.homeIncident = .Retired
                case GameEntryModel.Incident.Walkover.rawValue:
                    data.homeIncident = .Walkover
                    data.awayScore = 0
                    cell.updateAwayScore(toScore: "0")
                    pickerView.selectRow(0, inComponent: 1, animated: true)
                default :
                    data.homeScore = row
                    cell.updateHomeScore(toScore: "\(row)")
                }
                if let hi = data.homeIncident {
                    cell.updateHomeScore(toScore: hi.shortName())
                }
            } else {
                switch row {
                case GameEntryModel.Incident.Disqualified.rawValue:
                    data.awayIncident = .Disqualified
                case GameEntryModel.Incident.Retired.rawValue:
                    data.awayIncident = .Retired
                case GameEntryModel.Incident.Walkover.rawValue:
                    data.awayIncident = .Walkover
                    data.homeScore = 0
                    cell.updateHomeScore(toScore: "0")
                    pickerView.selectRow(0, inComponent: 0, animated: true)
                default :
                    data.awayScore = row
                    cell.updateAwayScore(toScore: "\(row)")
                }
                if let ai = data.awayIncident {
                    cell.updateAwayScore(toScore: ai.shortName())
                }
            }
            // update the home and away annotation views
            let matchCard = DataManager.sharedInstance.matchCard
            if matchCard.cardType!.isRepeatedNoteSuppressed() {
                let indexPaths : NSArray = matchCardCollectionView!.indexPathsForSelectedItems()
                if indexPaths.count > 0 {
                    let indexPath : NSIndexPath = indexPaths[0] as! NSIndexPath
                    let matchEntry = matchCard.matchEntries[indexPath.section]
                    NSNotificationCenter.defaultCenter().postNotificationName(EntryAnnotationReusableView.Notification.Identifier.ChangedMatchEntry, object: matchEntry)
                }
            }
        case Tags.League :
            DataManager.sharedInstance.matchCard.league = DataManager.sharedInstance.allLeagues[row]
            // clear lookups
            DataManager.sharedInstance.matchCard.clearLookups()
        case Tags.Division :
            DataManager.sharedInstance.matchCard.division = row + 1
        case Tags.Location :
            DataManager.sharedInstance.matchCard.homeClub = DataManager.sharedInstance.matchCard.league!.clubs![row]
        case Tags.HomeTeam_AllTeams :
            let teamInClub = DataManager.sharedInstance.matchCard.teams[row]
            DataManager.sharedInstance.matchCard.homeTeamBag!.team = teamInClub
            DataManager.sharedInstance.matchCard.homeClub = teamInClub.club
        case Tags.HomeTeam_Filter :
            DataManager.sharedInstance.matchCard.homeTeamBag!.team = DataManager.sharedInstance.matchCard.homeClub!.club!.teams![row]
        case Tags.AwayTeam :
            DataManager.sharedInstance.matchCard.awayTeamBag.team = DataManager.sharedInstance.matchCard.teams[row]
        default :
            assertionFailure("picker tag unknown")
        }
        NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.FadeLabel, object: pickerView)
        NSNotificationCenter.defaultCenter().postNotificationName(MatchPlayersReusableView.Notification.Identifier.Reload, object: nil)
    }
    // FIXME: Seem attributed string seem to not work...
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
//        let ats = NSMutableAttributedString(string: title, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(50)) ])
//        return ats
//    }
}

// MARK: UIScrollView delegates

extension MatchCardViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let headerSummarySize = MatchHeaderReusableView.Collection.Cell.Size
        let threshold = (headerSummarySize.height - statusBarHeight*2 )
        let divisor = yOffset + statusBarHeight
        let dividend = threshold
        var ratio = 1 - divisor / dividend
        if ratio < 0 {
            ratio = 0
        }
        // println("ratio=\(ratio), divisor=\(divisor), dividend=\(dividend), threshold=\(threshold) ")
        NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.ScrollToAlpha, object: ratio)
    }
}

// MARK:- UICollectionView delegates -

extension MatchCardViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.sharedInstance.matchCard.matchEntries[section].gameEntries.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return DataManager.sharedInstance.matchCard.matchEntries.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(GameEntryCell.Collection.ReuseIdentifier, forIndexPath: indexPath) as! GameEntryCell
        let gameEntry = DataManager.sharedInstance.matchCard.matchEntries[indexPath.section].gameEntries[indexPath.row]
        cell.data = gameEntry
        if Common.showColorBounds() {
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor.redColor().CGColor
        }
        else {
            cell.backgroundColor? = UIColor.clearColor()
            cell.homeScore?.backgroundColor = UIColor.clearColor()
            cell.awayScore?.backgroundColor = UIColor.clearColor()
        }
        cell.homeBar.hidden = (self.layout == .Matrix)
        cell.awayBar.hidden = (self.layout == .Matrix)
        cell.semicolon.hidden = (self.layout != .Matrix)
        cell.updateBars()
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! GameEntryCell
        if self.layout == .Standard {
            // TO EDIT MODE
            self.layout = .Edit
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            mockGameEntryTextField.becomeFirstResponder()
            var picker = mockGameEntryTextField.inputView as! UIPickerView
            if let hi = cell.data?.homeIncident {
                picker.selectRow(hi.rawValue, inComponent: 0, animated: true)
            } else {
                picker.selectRow(cell.homeScore.text!.toInt()! , inComponent: 0, animated: true)
            }
            if let ai = cell.data?.awayIncident {
                picker.selectRow(ai.rawValue, inComponent: 1, animated: true)
            } else {
                picker.selectRow(cell.awayScore.text!.toInt()! , inComponent: 1, animated: true)
            }
            cell.setFontSize(.Edit)
        } else if  self.layout == .Edit {
            // TO STANDARD MODE
            self.layout = .Standard
            cell.layer.borderColor = UIColor.clearColor().CGColor
            mockGameEntryTextField.resignFirstResponder()
            cell.setFontSize(.Standard)
        }
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.layout == .Standard {
            return true
        }
        let indexPaths : NSArray = collectionView.indexPathsForSelectedItems()
        for i in indexPaths {
            if indexPath.isEqual(i) {
                return true
            }
        }
        return false
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var matchCard = DataManager.sharedInstance.matchCard
        switch kind {
        // Separator
        case Separator.Kind :
            var separator = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Separator.ReuseIdentifier, forIndexPath: indexPath) as! UICollectionReusableView
            let sepTag = 1243
            if let s = separator.viewWithTag(sepTag) {
                // it's already there! if added, it'll thicken/darken more!
            } else {
                let count = CGFloat(matchCard.matchEntries.reduce(0, combine: { $0 + $1.gameEntries.count }))
                let sep = UIImageView(frame: CGRectMake(0, 0, 10, count * GameEntryCell.Collection.Edit.Cell.Size.height + 600))
                sep.tag = sepTag
                sep.image = UIImage(named: "Shadow_Right")
                separator.addSubview(sep)
            }
            return separator
        // Annotation - Away
        case EntryAnnotationReusableView.Collection.Away.Kind :
            var awayNote = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: EntryAnnotationReusableView.Collection.Away.ReuseIdentifier, forIndexPath: indexPath) as! EntryAnnotationAwayView
            awayNote.medalMatchWin.hidden = (!matchCard.cardType!.isMatchPointAggregated())
            awayNote.elementKind = kind
            if matchCard.cardType!.isRepeatedNoteSuppressed() {
                let matchEntry = matchCard.matchEntries[indexPath.section]
                awayNote.match = matchEntry
                awayNote.medalMatchWin.hidden = (indexPath.row > 0) || (!matchCard.cardType!.isMatchPointAggregated())
            } else {
                let gameEntry = matchCard.matchEntries[indexPath.section].gameEntries[indexPath.row]
                awayNote.game = gameEntry
            }
            return awayNote
        // Annotation - Home
        case EntryAnnotationReusableView.Collection.Home.Kind :
            var homeNote = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: EntryAnnotationReusableView.Collection.Home.ReuseIdentifier, forIndexPath: indexPath) as! EntryAnnotationReusableView
            homeNote.elementKind = kind
            homeNote.medalMatchWin.hidden = (!matchCard.cardType!.isMatchPointAggregated())
            if matchCard.cardType!.isRepeatedNoteSuppressed() {
                let matchEntry = matchCard.matchEntries[indexPath.section]
                homeNote.match = matchEntry
                homeNote.medalMatchWin.hidden = (indexPath.row > 0) || (!matchCard.cardType!.isMatchPointAggregated())
            } else {
                let gameEntry = matchCard.matchEntries[indexPath.section].gameEntries[indexPath.row]
                homeNote.game = gameEntry
            }
            return homeNote
        // Players - Away
        case MatchPlayersReusableView.Collection.Kind.Away :
            var awayPlayers = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MatchPlayersReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! MatchPlayersReusableView
            awayPlayers.delegate = self            
            awayPlayers.layer.zPosition = 20
            ToolTipManager.sharedInstance.needsDisplayTipView(ToolTipManager.Keys.PlayerPosition, forView: awayPlayers, withinSuperview: collectionView)
            return awayPlayers
        // Players - Home
        case MatchPlayersReusableView.Collection.Kind.Home :
            var homePlayers = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MatchPlayersReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! MatchPlayersReusableView
            homePlayers.elementKind = kind
            if self.layout == .Matrix {
                homePlayers.layer.zPosition = 9
            } else {
                homePlayers.layer.zPosition = 20
                homePlayers.playersCollectionView!.transform = CGAffineTransformMakeScale(-1, 1) // right align
            }
            homePlayers.delegate = self
            return homePlayers
        // Header
        case MatchHeaderReusableView.Collection.Kind :
            var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MatchHeaderReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! MatchHeaderReusableView
            headerView.leagueName.text = matchCard.leagueName
            headerView.divisionValue.text = "\(matchCard.division)"
            headerView.divOrdinal.text = matchCard.division.ordinal
            headerView.location.text = matchCard.location
            headerView.date.text = matchCard.dateString
            ToolTipManager.sharedInstance.needsDisplayTipView(ToolTipManager.Keys.MapPin, forView: headerView.locationButton, withinSuperview: collectionView)
            headerView.layer.zPosition = 10
            return headerView
        // Score header - Home
        case ScoreHeaderReusableView.Collection.Kind.Home :
            var scoreHomeView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ScoreHeaderReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! ScoreHeaderReusableView
            scoreHomeView.score.text = "\(matchCard.homeScore)"
            scoreHomeView.teamName.text = matchCard.homeTeamName
            scoreHomeView.kind = kind
            scoreHomeView.layer.zPosition = 10
            return scoreHomeView
        // Score header - Away
        case ScoreHeaderReusableView.Collection.Kind.Away :
            var scoreAwayView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ScoreHeaderReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! ScoreHeaderReusableView
            scoreAwayView.score.text = "\(matchCard.awayScore)"
            scoreAwayView.teamName.text = matchCard.awayTeamName
            scoreAwayView.kind = kind
            scoreAwayView.layer.zPosition = 10
            return scoreAwayView
        // Game Totals Footer
        case GameTotalsReusableView.Collection.Kind :
            var totalsView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: GameTotalsReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! GameTotalsReusableView
            totalsView.homeTotal.text = "\(matchCard.homeTotal)"
            totalsView.awayTotal.text = "\(matchCard.awayTotal)"
            return totalsView
        // Matrix Corner
        case MatrixCornerReusableView.Collection.Kind :
            var corner = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MatrixCornerReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! MatrixCornerReusableView
            corner.homeScore.text = "\(matchCard.homeScore)"
            corner.homeTeam.text = "\(String.substring(ofString: matchCard.homeTeamName, withCount: 4))(Home)"
            corner.awayScore.text = "\(matchCard.awayScore)"
            corner.awayTeam.text = "\(String.substring(ofString: matchCard.awayTeamName, withCount: 4))(Away)"
            corner.layer.zPosition = 20
            return corner
        default :
            assertionFailure("")
            return UICollectionReusableView()
        }
    }
}


// MARK:- Players Input delegates -

extension MatchCardViewController : PlayersInputControllerDelegate {
    func PlayerRegistration() {
        self.doneTappedPlayer()
        var rvc = UIStoryboard.playerRegistrationViewController()
        rvc?.elementKind = self.playersInputController.elementKind
        rvc?.delegate = self
        self.presentViewController(rvc!, animated: true, completion: nil)
    }
}


// MARK:- UIAlertView delegates -

extension MatchCardViewController : UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            switch alertView.tag {
            case Tags.AlertNoLeague:
                NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.ShowLeagues, object: nil)
            case Tags.AlertNoHomeTeam:
                NSNotificationCenter.defaultCenter().postNotificationName(ScoreHeaderReusableView.Notification.Identifier.ShowTeams, object:ScoreHeaderReusableView.Collection.Kind.Home)
            case Tags.AlertNoAwayTeam:
                NSNotificationCenter.defaultCenter().postNotificationName(ScoreHeaderReusableView.Notification.Identifier.ShowTeams, object: ScoreHeaderReusableView.Collection.Kind.Away)
            default :
                break
            }
        }
    }
}


// MARK:- Match Players delegates -

extension MatchCardViewController : MatchPlayersReusableViewDelegate {
    func needsPositionSelected() {
        self.doneTappedPlayer()
        self.clearPlayerPositionCell()
        var a = UIAlertView(title: "Warning", message: "Select a position in the team first. This is green highlighted", delegate: self, cancelButtonTitle: "OK")
        a.tag = Tags.AlertNoPosition
        a.show()
    }
    func clearPlayerPositionCell() {
        self.selectedPlayerPositionCell = nil
    }
}


// MARK:- Player Registration delegate -

extension MatchCardViewController : PlayerRegistrationDelegate {
    func isPositionSelected() -> Bool {
        return self.selectedPlayerPositionCell != nil
    }
    func assignPlayerToTeamInMatch(player: PlayerModel) {
        if let cell = self.selectedPlayerPositionCell {
            if let pp = cell.playingPlayer {
                pp.player = player
                Common.delay(1, closure: { () -> () in
                    cell.fade()
                    self.matchCardCollectionView?.reloadData()
                })
            }
        }
    }
}
