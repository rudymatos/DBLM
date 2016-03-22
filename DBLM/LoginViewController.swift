//
//  LoginViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/16/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    private let alertHelper = AlertsHelper.createStaticInstance
    private let userHelper = UserHelper.createStaticInstance
    private var blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if let _ = NSUserDefaults.standardUserDefaults().valueForKey("userId") as? String{
            if blInstance.userService.isStayLoggedIn{
                userHelper.processUserInformation(self)
            }
        }
    }
    
    func configureView(){
        ImageConfiguration().transformImage(loginImageView, shape: Shape.Circle(3.0, UIColor.whiteColor()))
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
    }
    
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navigationController  = segue.destinationViewController as? UINavigationController{
            if let selectLeagueVC = navigationController.topViewController as? SelectLeageViewController{
                selectLeagueVC.member = userHelper.currentMember
            }
        }
    }
    
    @IBAction func loginUser(sender: UIButton) {
        
        if let  email = usernameLabel.text, let password = passwordLabel.text{
            if email != "" && password != ""{
                self.loginButton.enabled = false
                self.loginActivityIndicator.startAnimating()
                
                blInstance.userService.login(email, password: password, response: {(loggedUser : BackendlessUser!) -> Void in
                    
                    if self.rememberMeSwitch.on{
                        NSUserDefaults.standardUserDefaults().setValue("userId", forKey: loggedUser.objectId)
                        self.blInstance.userService.setStayLoggedIn(true)
                    }
                    
                    self.userHelper.processUserInformation(self)
                    self.loginButton.enabled = true
                    self.loginActivityIndicator.stopAnimating()
                    
                    
                    }, error: {(error : Fault!) -> Void in
                        self.loginButton.enabled = true
                        self.loginActivityIndicator.stopAnimating()
                        self.alertHelper.createSimpleNotificationAlert(self, title:"Error loging", message: error.message, shouldDismissCurrentView: false, completion: nil)
                })
            }else{
                self.alertHelper.createSimpleNotificationAlert(self, title:"Error Login", message: "Make sure you enter your email/password to login", shouldDismissCurrentView: false, completion: nil)
            }
        }else{
            self.alertHelper.createSimpleNotificationAlert(self, title:"Error Login", message: "Make sure you enter your email/password to login", shouldDismissCurrentView: false, completion: nil)
        }
    }
    
    
    //MARK: HELPER FUNCTIONS
}
