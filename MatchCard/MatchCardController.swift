//
//  MatchCardController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 05/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

var matchCard = MatchCardModel()

enum LayoutType {
    case Standard, Edit, Matrix
}

class MatchCardController : NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var layouts : [LayoutType : UICollectionViewLayout] = [.Standard : MatchCardStandardLayout(), .Edit : MatchEntryEditLayout()]
    var picker = UIPickerView()
    weak var matchCollectionView : UICollectionView? {
        didSet {
            self.matchCollectionView?.setCollectionViewLayout(self.layouts[.Standard]!, animated: false)
        }
    }
    
    override init(){
        super.init()
        matchCard.MatchEntries = [MatchEntryModel]()
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 17, awayScore: 21))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 1, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 2, awayScore: 21))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 3, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 4, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 5, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 6, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 7, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 8, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 9, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 10, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 11, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 12, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 13, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 14, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 15, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 16, awayScore: 0))
        matchCard.MatchEntries.append(MatchEntryModel(homeScore: 17, awayScore: 0))
    }
    
    //
    // MARK: Collection View
    //
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchCard.MatchEntries.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(MatchEntryCell.constantReuseIdentifier, forIndexPath: indexPath) as! MatchEntryCell
        
        let matchEntry = matchCard.MatchEntries[indexPath.row]
        cell.data = matchEntry
        
        picker.delegate = self
        picker.dataSource = self
        cell.homeScoreField.inputView = picker
        cell.homeScoreField.text = "\(matchEntry.HomeScore)"
        cell.homeScoreField.userInteractionEnabled = false
        cell.homeScore.text = "\(matchEntry.HomeScore)"
        cell.awayScore.text = "\(matchEntry.AwayScore)"
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
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MatchEntryCell
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MatchEntryCell
        cell.layer.borderColor = UIColor.clearColor().CGColor
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! MatchEntryCell
        if (collectionView.collectionViewLayout.isEqual(self.layouts[.Standard]!)){
            // TO EDIT MODE
            collectionView.setCollectionViewLayout(self.layouts[.Edit]!, animated: true, completion: { (bool) -> Void in
            })
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.homeScoreField.userInteractionEnabled = true
            cell.homeScoreField.becomeFirstResponder()
            picker.selectRow(cell.homeScore.text!.toInt()! , inComponent: 0, animated: true)
            picker.selectRow(cell.awayScore.text!.toInt()! , inComponent: 1, animated: true)
            cell.setFontSize(.Edit)
        } else if (collectionView.collectionViewLayout.isEqual(self.layouts[.Edit]!)) {
            // TO STANDARD MODE
            collectionView.setCollectionViewLayout(self.layouts[.Standard]!, animated: true)
            cell.layer.borderColor = UIColor.clearColor().CGColor
            cell.homeScoreField.resignFirstResponder()
            cell.homeScoreField.userInteractionEnabled = false
            cell.setFontSize(.Standard)
        }
    }
    //
    // MARK: Supplementary views
    //
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case MatchPlayersReusableView.constantAwayKind :
            return collectionView.dequeueReusableSupplementaryViewOfKind(MatchPlayersReusableView.constantAwayKind, withReuseIdentifier: MatchPlayersReusableView.constantReuseIdentifier, forIndexPath: indexPath) as! MatchPlayersReusableView
        case MatchPlayersReusableView.constantHomeKind :
            return collectionView.dequeueReusableSupplementaryViewOfKind(MatchPlayersReusableView.constantHomeKind, withReuseIdentifier: MatchPlayersReusableView.constantReuseIdentifier, forIndexPath: indexPath) as! MatchPlayersReusableView
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
        let indexPaths : NSArray = self.matchCollectionView!.indexPathsForSelectedItems()
        let indexPath : NSIndexPath = indexPaths[0] as! NSIndexPath
        let cell = self.matchCollectionView?.cellForItemAtIndexPath(indexPath) as! MatchEntryCell
        let data = cell.data!
        if component == 0 {
            data.HomeScore = row
            cell.homeScore?.text = "\(row)"
        } else {
            data.AwayScore = row
            cell.awayScore?.text = "\(row)"
        }
        cell.updateBars()
    }
}

