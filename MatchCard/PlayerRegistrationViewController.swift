//
//  PlayerRegistrationViewController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 24/07/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

@objc (PlayerRegistrationViewController) class PlayerRegistrationViewController: UIViewController {

    struct PhotoOptions {
        struct Cancel {
            static let Description = "Cancel"
            static let ButtonIndex = 0
        }
        struct TakeNew {
            static let Description = "Take Photo"
            static let ButtonIndex = 1
        }
        struct Existing {
            static let Description = "Choose Existing"
            static let ButtonIndex = 2
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonSetImage: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var flagReserved: UISwitch!
    var activeField : UITextField?
    var imageData : NSData?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.nameTextField.becomeFirstResponder()
        self.nameTextField.delegate = self
    }
    @IBAction func setPlayerImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) || UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            var sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: PhotoOptions.Cancel.Description, destructiveButtonTitle: nil, otherButtonTitles: PhotoOptions.TakeNew.Description,  PhotoOptions.Existing.Description)
            sheet.showInView(self.view)
        } else if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            self.displayImagePickerWithSourceType(.Camera)
        } else if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            self.displayImagePickerWithSourceType(.PhotoLibrary)
        }
    }
    @IBAction func cancelSave(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }    
    @IBAction func saveAndDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardDidShow(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let kbRect = self.view.convertRect(keyboardRect, fromView: nil)
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbRect.size.height, right: 0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= kbRect.size.height
            let p = self.activeField?.frame.origin
            let f = self.activeField?.frame
            self.scrollView.scrollRectToVisible(f!, animated: true)
//            if !CGRectContainsPoint(aRect, p!) {
//                self.scrollView.scrollRectToVisible(f!, animated: true)
//            }
        }
    }
    func keyboardWillBeHidden(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsetsZero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
}

extension PlayerRegistrationViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeField = textField
    }
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeField = nil
    }
}

extension PlayerRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        image.resize(CGSizeMake(200, 200), completionHandler: { (resizedImage, data) -> () in
            self.buttonSetImage.setTitle("", forState: .Normal)
            self.buttonSetImage.setImage(resizedImage, forState: .Normal)
            self.imageData = data
        })
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func displayImagePickerWithSourceType(sourceType : UIImagePickerControllerSourceType) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.modalTransitionStyle = .CoverVertical
        self.presentViewController(imagePicker, animated: true) { () -> Void in }
    }
}

extension PlayerRegistrationViewController: UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case PhotoOptions.Cancel.ButtonIndex :
            return
        case PhotoOptions.TakeNew.ButtonIndex :
            self.displayImagePickerWithSourceType(UIImagePickerControllerSourceType.Camera)
        default :
            self.displayImagePickerWithSourceType(UIImagePickerControllerSourceType.PhotoLibrary)
        }
    }
}





