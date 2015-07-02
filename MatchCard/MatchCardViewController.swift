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
    @IBOutlet weak var containingView : UIView?
    @IBOutlet weak var matchCardCollectionView : UICollectionView?
    var delegate: MatchCardViewControllerDelegate?
    let matchCardController = MatchCardController()
    override func viewDidLoad() {
        super.viewDidLoad()
        let matchHeaderNib = MatchHeaderReusableView.constantReuseIdentifier
        let scoreHeaderNib = ScoreHeaderReusableView.constantReuseIdentifier
        let matchEntryNib = MatchEntryCell.constantReuseIdentifier
        let matchPlayersNib = MatchPlayersReusableView.constantReuseIdentifier
        let nibHeader = UINib(nibName: matchHeaderNib, bundle: nil)
        let nibScore = UINib(nibName: scoreHeaderNib, bundle: nil)
        let nibMatchEntry = UINib(nibName: matchEntryNib, bundle:nil)
        let nibPlayers = UINib(nibName: matchPlayersNib, bundle: nil)
        matchCardCollectionView?.delegate = matchCardController
        matchCardCollectionView?.dataSource = matchCardController
        matchCardCollectionView?.registerNib(nibHeader, forSupplementaryViewOfKind: MatchHeaderReusableView.constantKind, withReuseIdentifier: MatchHeaderReusableView.constantReuseIdentifier)
        matchCardCollectionView?.registerNib(nibScore, forSupplementaryViewOfKind: ScoreHeaderReusableView.constantHomeKind, withReuseIdentifier: ScoreHeaderReusableView.constantReuseIdentifier)
        matchCardCollectionView?.registerNib(nibScore, forSupplementaryViewOfKind: ScoreHeaderReusableView.constantAwayKind, withReuseIdentifier: ScoreHeaderReusableView.constantReuseIdentifier)
        matchCardCollectionView?.registerNib(nibMatchEntry, forCellWithReuseIdentifier: MatchEntryCell.constantReuseIdentifier)
        matchCardCollectionView?.registerNib(nibPlayers, forSupplementaryViewOfKind: MatchPlayersReusableView.constantHomeKind, withReuseIdentifier: MatchPlayersReusableView.constantReuseIdentifier)
        matchCardCollectionView?.registerNib(nibPlayers, forSupplementaryViewOfKind: MatchPlayersReusableView.constantAwayKind, withReuseIdentifier: MatchPlayersReusableView.constantReuseIdentifier)
        matchCardCollectionView?.setCollectionViewLayout(MatchCardStandardLayout(), animated: false)
        matchCardController.matchCollectionView = self.matchCardCollectionView
        if Common.showColorBounds() == false {
            matchCardCollectionView?.backgroundColor = UIColor.clearColor()
            containingView?.backgroundColor = UIColor.whiteColor()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moreMethodOfReceivedNotification:", name:MatchHeaderReusableView.constantMoreNotification, object: nil)
    }
    @objc private func moreMethodOfReceivedNotification(notification: NSNotification){
        delegate?.toggleLeftPanel?()
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



