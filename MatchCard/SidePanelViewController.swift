//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
protocol SidePanelViewControllerDelegate {
  func itemSelected(item: MenuItem)
}

class SidePanelViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var delegate: SidePanelViewControllerDelegate?
    var items: Array<MenuItem>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(MenuItemCell.TableView.ReuseIdentifier, forIndexPath: indexPath) as! MenuItemCell
    cell.configureForItem(items[indexPath.row])
    return cell
  }
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedItem = items[indexPath.row]
    delegate?.itemSelected(selectedItem)    
  }
}

class MenuItemCell: UITableViewCell {
    struct TableView {
        static let ReuseIdentifier = "MenuItemCell"
    }
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    func configureForItem(item: MenuItem) {
        itemImageView.image = item.image
        imageNameLabel.text = item.title
    }
}