//
//  DesignableUITextField.swift
//  Afostream
//
//  Created by Bahri on 04/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    
    
override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
 var textRect = super.leftViewRect(forBounds: bounds)
textRect.origin.x += leftPadding
 return textRect
}
    
    @IBInspectable var leftImage: UIImage? {
didSet {
updateView()
}
}

@IBInspectable var leftPadding: CGFloat = 0

@IBInspectable var color: UIColor = UIColor.lightGray {
didSet {
updateView()
}
}
    
    func updateView() {
if let image = leftImage {
leftViewMode = UITextFieldViewMode.always
let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 17, height: 15))
imageView.image = image

imageView.tintColor = color
leftView = imageView
} else {
leftViewMode = UITextFieldViewMode.never
leftView = nil
}

// Placeholder text color
attributedPlaceholder = NSAttributedString(string:
placeholder != nil ? placeholder! : "",attributes:[NSForegroundColorAttributeName: color])
}
    
}
