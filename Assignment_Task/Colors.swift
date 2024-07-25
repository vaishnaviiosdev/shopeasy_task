//
//  Colors.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 23/07/24.
//

import Foundation
import UIKit


extension UIColor {
    
    static var ColorGradinetFirstColour: UIColor {
        return UIColor(hexString: "#FF9C16")!
    }
    
    static var ColorGradinetSecondColour: UIColor {
        return UIColor(hexString: "#FFDA06")!
    }

    //MARK: - init method with hex string and alpha(default: 1)
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)        }
        else {
            return nil
        }
    }
}
