//
//  UIViewControllerExtension.swift
//  Assignment_Task
//
//  Created by YASAR B on 25/07/24.
//

import Foundation
import UIKit

typealias alertBlock = (_ response: Bool) -> Void

extension NSObject {
    
    func showAlertView(title: String,message: String, positiveActionTitle: String, negativeActionTitle: String, callback: @escaping alertBlock){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: positiveActionTitle, style: .default) { (action) in
            callback(true)
        }
        let cancelAction = UIAlertAction(title: negativeActionTitle, style: .default) { (action) in
            callback(false)
        }
        
        let titleCustomFont = [NSAttributedString.Key.font: UIFont(name: AppFontName.AppBoldFont.rawValue, size: 15)!]
        let msgCustomFont = [NSAttributedString.Key.font: UIFont(name: AppFontName.AppMediumFont.rawValue, size: 13)!]
        let attribTitleString = NSAttributedString(string: title, attributes: titleCustomFont)
        let attribMsgString = NSAttributedString(string: message, attributes: msgCustomFont)
        alert.setValue(attribTitleString, forKey: "attributedTitle")
        alert.setValue(attribMsgString, forKey: "attributedMessage")
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        topMostViewController().present(alert, animated: true, completion: nil)
    }
    
    public func topMostViewController() -> UIViewController {
        return self.topMostViewController(withRootViewController: (UIApplication.shared.keyWindow?.rootViewController!)!)
    }
    
    public func topMostViewController(withRootViewController rootViewController: UIViewController) -> UIViewController {
        if (rootViewController is UITabBarController) {
            let tabBarController = (rootViewController as! UITabBarController)
            return self.topMostViewController(withRootViewController: tabBarController.selectedViewController!)
        }
        else if (rootViewController is UINavigationController) {
            let navigationController = (rootViewController as! UINavigationController)
            return self.topMostViewController(withRootViewController: navigationController.visibleViewController!)
        }
        else if rootViewController.presentedViewController != nil {
            let presentedViewController = rootViewController.presentedViewController!
            return self.topMostViewController(withRootViewController: presentedViewController)
        }
        else {
            return rootViewController
        }
    }
}
