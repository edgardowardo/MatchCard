//
//  MatchCardViewController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 05/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol MatchCardViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class MatchCardViewController : UIViewController {
    struct Notification {
        struct Identifier {
            static let ReloadData = "NotificationIdentifierOfReloadData"
        }
    }
    struct Tags {
        static let League = 1
        static let Division = 2
        static let Away = 3
        static let Home = 4
    }
    @IBOutlet weak var containingView : UIView?
    @IBOutlet weak var matchCardCollectionView : UICollectionView?
    var delegate: MatchCardViewControllerDelegate?
    let mockLeagueTextField = UITextField(frame: CGRectZero)
    let mockDivTextField = UITextField(frame: CGRectZero)
    let matchCardController = MatchCardController()
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
        // keyboard toolbar
        var doneToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: Selector("doneTap"))
        doneToolbar.setItems([flexibleSpace, doneButton], animated: true)
        self.mockLeagueTextField.inputAccessoryView = doneToolbar
        self.mockDivTextField.inputAccessoryView = doneToolbar
    }
    func doneTap() {
        self.mockLeagueTextField.resignFirstResponder()
        self.mockDivTextField.resignFirstResponder()
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

extension MatchCardViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case Tags.League :
            return DataManager.sharedInstance.leagues.count
        case Tags.Division :
            return DataManager.sharedInstance.matchCard.league!.divisions
        default :
            return 0
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch pickerView.tag {
        case Tags.League :
            return DataManager.sharedInstance.leagues[row].name
        case Tags.Division :
            return "\(row+1)"
        default :
            return "unknown"
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case Tags.League :
            DataManager.sharedInstance.matchCard.league = DataManager.sharedInstance.leagues[row]
        case Tags.Division :
            DataManager.sharedInstance.matchCard.division = row + 1
        default :
            assertionFailure("picker tag unknown")
        }
        NSNotificationCenter.defaultCenter().postNotificationName(MatchHeaderReusableView.Notification.Identifier.FadeLabel, object: pickerView)
    }
}