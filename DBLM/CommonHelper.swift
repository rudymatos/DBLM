//
//  CommonHelper.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/19/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation

class CommonHelper{
    
    private let blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    private let alertHelper = AlertsHelper.createStaticInstance
    
    private func logoutUser(user:Member, currentView : UIViewController){
        blInstance.userService.logout({ (response:AnyObject!) -> Void in
            let loginView = currentView.storyboard?.instantiateViewControllerWithIdentifier("loginView")
            UIApplication.sharedApplication().keyWindow?.rootViewController = loginView
            }, error: { (error:Fault!) -> Void in
                self.alertHelper.createSimpleNotificationAlert(currentView, title: "Logout Error", message: "There was an error trying to logout the user with message \(error.message)", shouldDismissCurrentView: false, completion: nil)
                
        })
    }
    
    func createLogoutConfirmationAlert(user : Member, currentView : UIViewController){
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .Alert)
        let logout = UIAlertAction(title: "Yeah, log me out", style: UIAlertActionStyle.Destructive){ action in
            self.logoutUser(user, currentView: currentView)
        }
        let cancel = UIAlertAction(title:"Cancel" , style: .Default, handler:nil)
        alert.addAction(logout)
        alert.addAction(cancel)
        currentView.presentViewController(alert, animated: true, completion: nil)
    }
    
    func generateLCode() -> String{
        let  letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890"
        var code = ""
        for _ in 1...10{
            let randomIndex = arc4random_uniform(UInt32(letters.characters.count))
            code.append(letters[letters.startIndex.advancedBy(Int(randomIndex))])
        }
        return code
    }
    
     func getCurrentDateString() -> String{
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateFormatString = formatter.stringFromDate(NSDate())
        return dateFormatString
    }
}