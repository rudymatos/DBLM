//
//  AlertsHelper.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/19/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation
import UIKit

class AlertsHelper{
    
    static let createStaticInstance = AlertsHelper()
    
    func createSimpleNotificationAlert(view : UIViewController, title: String, message: String, shouldDismissCurrentView : Bool, completion : (() -> Void)?){
        view.view.endEditing(true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        var okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        if shouldDismissCurrentView{
            okAction = UIAlertAction(title: "OK", style: .Default) { okAction in
                view.dismissViewControllerAnimated(true, completion: nil)
                completion?()
            }
        }
        alert.addAction(okAction)
        view.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func createNotificationInNavigationViewController(view : UIViewController , title : String, message : String, shouldDismissCurrentView : Bool){
        view.view.endEditing(true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        var okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        if shouldDismissCurrentView {
            okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
               view.navigationController?.popViewControllerAnimated(true)
            })
        }
        alert.addAction(okAction)
        view.presentViewController(alert, animated: true, completion: nil)

        
    }
    
    
}