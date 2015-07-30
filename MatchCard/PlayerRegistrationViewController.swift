//
//  PlayerRegistrationViewController.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 24/07/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol PlayerRegistrationDelegate {
    func assignPlayerToTeamInMatch(player : PlayerModel)
    func isPositionSelected() -> Bool
}


@objc (PlayerRegistrationViewController) class PlayerRegistrationViewController: UIViewController {
    struct Alert {
        struct Changed {
            static let Tag = 1001
            static let Title = "Changed"
            static let Message = "Data is changed, continue to leave or cancel exit?"
            struct Cancel {
                static let Index = 0
                static let Description = "Cancel"
            }
            struct Continue {
                static let Index = 1
                static let Description = "Continue"
            }
        }
        struct NoName {
            static let Title = "No Name"
            static let Message = "Please enter name before saving"
            struct Ok {
                static let Description = "Ok"
            }
        }
    }
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
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var flagReserved: UISwitch!
    var activeField : UITextField?
    var imageData : NSData?
    var elementKind = MatchPlayersReusableView.Collection.Kind.Away
    var player : PlayerModel?
    var isDirty = false
    var delegate : PlayerRegistrationDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.textFieldName.delegate = self
        self.buttonSetImage.layer.cornerRadius = self.buttonSetImage.frame.size.width / 2
        addDoneToolbar(toTextField: self.textFieldEmail)
        addDoneToolbar(toTextField: self.textFieldName)
        addDoneToolbar(toTextField: self.textFieldPhone)
    }
    func addDoneToolbar(#toTextField : UITextField, withSelector selector: String = "doneTappedGeneric" ) {
        var doneToolbar = UIToolbar(frame: CGRectMake(0, 0, UIToolbar.Size.Width, UIToolbar.Size.Height))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: Selector(selector))
        doneToolbar.setItems([flexibleSpace, doneButton], animated: true)
        toTextField.inputAccessoryView = doneToolbar
    }
    func doneTappedGeneric() {
        self.textFieldEmail.resignFirstResponder()
        self.textFieldName.resignFirstResponder()
        self.textFieldPhone.resignFirstResponder()
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
        if self.isDirty {
            var a = UIAlertView(title: Alert.Changed.Title, message: Alert.Changed.Message, delegate: self, cancelButtonTitle: Alert.Changed.Cancel.Description, otherButtonTitles: Alert.Changed.Continue.Description)
            a.tag = Alert.Changed.Tag
            a.show()
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func saveAndDismiss(sender: AnyObject) {
        if count(self.textFieldName.text) > 0 {
            if self.elementKind == MatchPlayersReusableView.Collection.Kind.Away {
                if let awayTeam = DataManager.sharedInstance.matchCard.awayTeamBag.team {
                    assignPlayer(self.player, toTeamInClub: awayTeam)
                }
            } else if self.elementKind == MatchPlayersReusableView.Collection.Kind.Home {
                if let homeTeam = DataManager.sharedInstance.matchCard.homeTeamBag.team {
                    assignPlayer(self.player, toTeamInClub: homeTeam)
                }
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            UIAlertView(title: Alert.NoName.Title, message: Alert.NoName.Message, delegate: self, cancelButtonTitle: Alert.NoName.Ok.Description).show()
        }
    }
    func assignPlayer(player : PlayerModel?, toTeamInClub team: TeamInClubModel) {
        if team.players == nil {
            team.players = []
        }
        if self.flagReserved.on {
            if let clubRelation = team.club {
                if let club = clubRelation.club {
                    if club.players == nil {
                        club.players = []
                    }
                    club.players?.append(PlayerInClubModel(player!))
                    if delegate!.isPositionSelected() == false {
                        Common.delay(0.5, closure: { () -> () in
                            UIAlertView(title: "Registration", message: "Player \(player!.name) is now registered with club \(club.name) as a rereserve player.", delegate: self, cancelButtonTitle: "Ok").show()
                        })
                    }
                }
            }
        } else {
            team.players?.append(PlayerInTeamModel(player!))
            if delegate!.isPositionSelected() == false {
                Common.delay(0.5, closure: { () -> () in
                    UIAlertView(title: "Registration", message: "Player \(player!.name) is now registered with team \(team.name).", delegate: self, cancelButtonTitle: "Ok").show()
                })
            }
        }
        delegate?.assignPlayerToTeamInMatch(player!)
    }
    override func viewDidAppear(animated: Bool) {
        self.textFieldName.becomeFirstResponder()
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
        // Create a new player every time
        self.player = PlayerModel()
        self.isDirty = false
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardDidShow(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if let af = self.activeField {
                let kbRect = self.view.convertRect(keyboardRect, fromView: nil)
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbRect.size.height, right: 0)
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
                var aRect = self.view.frame
                aRect.size.height -= kbRect.size.height
                let p = af.frame.origin
                let f = af.frame
                self.scrollView.scrollRectToVisible(f, animated: true)
                //            if !CGRectContainsPoint(aRect, p!) {
                //                self.scrollView.scrollRectToVisible(f!, animated: true)
                //            }
            }
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
        if textField.isEqual(self.textFieldName) {
            self.player?.name = self.textFieldName.text
        }
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.isDirty = true
        return true
    }
}

extension PlayerRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = UIImage.croppedImageWithImagePickerInfo(info)
        image.resize(CGSizeMake(200, 200), completionHandler: { (resizedImage, data) -> () in
            self.buttonSetImage.setTitle("", forState: .Normal)
            self.buttonSetImage.setImage(resizedImage, forState: .Normal)
            self.imageData = data
            self.player?.imageFile = resizedImage
            self.isDirty = true
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

// MARK:
// MARK: UIAlertView delegates
// MARK:
extension PlayerRegistrationViewController : UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch alertView.tag {
        case Alert.Changed.Tag :
            if buttonIndex == Alert.Changed.Continue.Index {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        default :
            break
        }
    }
}

