//
//  ViewController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 27/05/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var awayPlayersCollectionView: UICollectionView?
    @IBOutlet weak var homePlayersCollectionView: UICollectionView?
    let awayPlayersController = MatchPlayersController ()
    let homePlayersController = MatchPlayersController ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        awayPlayersCollectionView?.delegate = awayPlayersController
        awayPlayersCollectionView?.dataSource = awayPlayersController
        homePlayersCollectionView?.delegate = homePlayersController
        homePlayersCollectionView?.dataSource = homePlayersController
        homePlayersCollectionView!.transform = CGAffineTransformMakeScale(-1, 1) // right align
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

