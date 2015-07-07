//
//  ContainerViewController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 29/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
}

class ContainerViewController: UIViewController, UIGestureRecognizerDelegate {
    static var isPannable = true
    var centerNavigationController: UINavigationController!
    var centerViewController: MatchCardViewController!
    
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var leftViewController: SidePanelViewController?
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.navigationBarHidden = true
        centerNavigationController.didMoveToParentViewController(self)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: Gesture recognizer
    
    var gestureIsDraggingFromLeftToRight = false
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        if ContainerViewController.isPannable == false {
            return
        }
        switch(recognizer.state) {
        case .Began:
            gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
            if (currentState == .BothCollapsed) {
                if (gestureIsDraggingFromLeftToRight) {
                    addLeftPanelViewController()
                } else {
                }
                showShadowForCenterViewController(true)
            }
        case .Changed:
            // Drag only to the right
            let x = (recognizer.view!.center.x - view.bounds.size.width / 2)
            let v = recognizer.velocityInView(view).x
            if x >= 0 {
                if x == 0 && gestureIsDraggingFromLeftToRight == false {
                    break
                }
                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
                recognizer.setTranslation(CGPointZero, inView: view)
            }
        case .Ended:
            if (leftViewController != nil) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
}

// MARK: CenterViewController delegate

extension ContainerViewController: MatchCardViewControllerDelegate {
    
    func toggleLeftPanel() {
        if ContainerViewController.isPannable == false {
            return
        }        
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .LeftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            leftViewController!.items = MenuItem.allItems()
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = centerViewController
        view.insertSubview(sidePanelController.view, atIndex: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
// FIXME: This shadow will make animation choppy. Look for a shadow image instead!
//        if (shouldShowShadow) {
//            centerNavigationController.view.layer.shadowOpacity = 0.8
//        } else {
//            centerNavigationController.view.layer.shadowOpacity = 0.0
//        }
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
    }
    class func centerViewController() -> MatchCardViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MatchCardViewController") as? MatchCardViewController
    }
    
}