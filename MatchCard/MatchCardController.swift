//
//  MatchCardController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 05/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

enum LayoutType {
    case Standard, Edit, Matrix
}

class MatchCardController : NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    var matchCard = DataManager.sharedInstance.matchCard
    var layouts : [LayoutType : UICollectionViewLayout] = [.Standard : MatchCardStandardLayout(), .Edit : MatchEntryEditLayout()]
    var layout : LayoutType = .Standard {
        didSet {
            self.matchCollectionView?.setCollectionViewLayout(self.layouts[self.layout]!, animated: true)
        }
    }
    var picker = UIPickerView()
    weak var matchCollectionView : UICollectionView? {
        didSet {
            self.layout = .Standard
        }
    }
    override init(){
        super.init()
    }
    //
    // MARK: Collection View
    //
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchCard.matchEntries.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(MatchEntryCell.Collection.ReuseIdentifier, forIndexPath: indexPath) as! MatchEntryCell
        let matchEntry = matchCard.matchEntries[indexPath.row]
        cell.data = matchEntry
        // picker
        picker.delegate = self
        picker.dataSource = self
        cell.homeScoreField.inputView = picker
        // keyboard toolbar
        var doneToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: Selector("doneTapped"))
        doneToolbar.setItems([flexibleSpace, doneButton], animated: true)
        cell.homeScoreField.inputAccessoryView = doneToolbar
        cell.homeScoreField.text = "\(matchEntry.homeScore)"
        cell.homeScoreField.userInteractionEnabled = false
        cell.homeScore.text = "\(matchEntry.homeScore)"
        cell.awayScore.text = "\(matchEntry.awayScore)"
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
        cell.updateBars()
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! MatchEntryCell
        if self.layout == .Standard {
            // TO EDIT MODE
            self.layout = .Edit
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.homeScoreField.userInteractionEnabled = true
            cell.homeScoreField.becomeFirstResponder()
            picker.selectRow(cell.homeScore.text!.toInt()! , inComponent: 0, animated: true)
            picker.selectRow(cell.awayScore.text!.toInt()! , inComponent: 1, animated: true)
            cell.setFontSize(.Edit)
        } else if  self.layout == .Edit {
            // TO STANDARD MODE
            self.layout = .Standard
            cell.layer.borderColor = UIColor.clearColor().CGColor
            cell.homeScoreField.resignFirstResponder()
            cell.homeScoreField.userInteractionEnabled = false
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
    //
    // MARK: Supplementary views
    //
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case MatchPlayersReusableView.Collection.Kind.Away :
            return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MatchPlayersReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! MatchPlayersReusableView
        case MatchPlayersReusableView.Collection.Kind.Home :
            var homePlayers = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MatchPlayersReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! MatchPlayersReusableView
            homePlayers.elementKind = kind
            homePlayers.playersCollectionView!.transform = CGAffineTransformMakeScale(-1, 1) // right align
            return homePlayers
        case MatchHeaderReusableView.Collection.Kind :
            var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MatchHeaderReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! MatchHeaderReusableView
            headerView.leagueName.text = matchCard.leagueName
            headerView.division.text = "\(matchCard.division)"
            headerView.location.text = matchCard.location
            headerView.date.text = matchCard.dateString
            return headerView
        case ScoreHeaderReusableView.Collection.Kind.Home :
            var scoreHomeView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ScoreHeaderReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! ScoreHeaderReusableView
            scoreHomeView.score.text = matchCard.homeScore
            scoreHomeView.teamName.text = matchCard.homeTeamName
            return scoreHomeView
        case ScoreHeaderReusableView.Collection.Kind.Away :
            var scoreAwayView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ScoreHeaderReusableView.Collection.ReuseIdentifier, forIndexPath: indexPath) as! ScoreHeaderReusableView
            scoreAwayView.score.text = matchCard.awayScore
            scoreAwayView.teamName.text = matchCard.awayTeamName
            return scoreAwayView
        default :
            assertionFailure("")
            return UICollectionReusableView()
        }
    }
    //
    // MARK: Picker view
    //
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 31
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(row)"
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = self.cellSelected()
        let data = cell.data!
        if component == 0 {
            data.homeScore = row
            cell.homeScore?.text = "\(row)"
        } else {
            data.awayScore = row
            cell.awayScore?.text = "\(row)"
        }
        cell.updateBars()
    }
    // MARK: Helpers
    func cellSelected() -> MatchEntryCell {
        let indexPaths : NSArray = self.matchCollectionView!.indexPathsForSelectedItems()
        let indexPath : NSIndexPath = indexPaths[0] as! NSIndexPath
        let cell = self.matchCollectionView?.cellForItemAtIndexPath(indexPath) as! MatchEntryCell
        return cell
    }
    func doneTapped() {
        if self.layout == .Edit {
            // TO STANDARD MODE
            self.layout = .Standard
            let cell = self.cellSelected()
            cell.layer.borderColor = UIColor.clearColor().CGColor
            cell.homeScoreField.resignFirstResponder()
            cell.homeScoreField.userInteractionEnabled = false
            cell.setFontSize(.Standard)
            cell.layer.borderColor = UIColor.clearColor().CGColor
        }
    }
}

