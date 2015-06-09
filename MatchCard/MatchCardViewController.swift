//
//  MatchCardViewController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 05/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class MatchCardViewController : UIViewController {
    
    @IBOutlet weak var matchCardCollectionView : UICollectionView?
    let matchCardController = MatchCardController()
    let matchCardNib = "MatchCardViews"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchCardCollectionView?.delegate = matchCardController
        matchCardCollectionView?.dataSource = matchCardController
        matchCardCollectionView?.backgroundColor = UIColor.whiteColor()
        
        let nib = UINib(nibName: matchCardNib, bundle:nil)
        matchCardCollectionView?.registerNib(nib, forCellWithReuseIdentifier: MatchEntryCell.constantReuseIdentifier)
        matchCardCollectionView?.setCollectionViewLayout(MatchCardStandardLayout(), animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



