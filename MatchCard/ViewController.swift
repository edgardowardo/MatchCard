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
    let awayPlayersController = PlayersController ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        awayPlayersCollectionView?.delegate = awayPlayersController
        awayPlayersCollectionView?.dataSource = awayPlayersController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

