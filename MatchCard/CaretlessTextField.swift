//
//  MyTextField.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 09/06/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class CaretlessTextField : UITextField {
    override func caretRectForPosition(position: UITextPosition!) -> CGRect {
        return CGRectZero
    }
    
    override func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
//        if (gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer)){
            gestureRecognizer.enabled = false
//        }
//        super.addGestureRecognizer(gestureRecognizer)
    }
}