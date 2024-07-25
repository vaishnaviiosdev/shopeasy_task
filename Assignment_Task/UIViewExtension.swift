//
//  UIViewExtension.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 23/07/24.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable
    var cornerRadius : CGFloat {
        get{
            return self.layer.cornerRadius
        }
        set(newValue) {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth : CGFloat {
        get {
            return self.layer.borderWidth
        }
        set(newValue) {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor : UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var offsetShadow : CGSize {
        get {
            return self.layer.shadowOffset
        }
        set(newValue) {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity : Float {
        get{
            return self.layer.shadowOpacity
        }
        set(newValue) {
            self.layer.shadowOpacity = newValue
        }
        
    }
    
    @IBInspectable
    var shadowColor : UIColor? {
        get{
            return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var maskToBounds : Bool {
        get {
            return self.layer.masksToBounds
        }
        set(newValue) {
            self.layer.masksToBounds = newValue
        }
    }
}

extension UITextField {
    @IBInspectable
    var placeholderColor: UIColor? {
        get {
            // Retrieve the current placeholder color
            let attributedString = self.attributedPlaceholder
            var range = NSRange(location: 0, length: attributedString?.length ?? 0)
            let attributes = attributedString?.attributes(at: 0, effectiveRange: &range)
            return attributes?[.foregroundColor] as? UIColor
        }
        set {
            // Set the placeholder color
            guard let placeholder = self.placeholder else { return }
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: newValue ?? UIColor.placeholderText])
        }
    }
}

