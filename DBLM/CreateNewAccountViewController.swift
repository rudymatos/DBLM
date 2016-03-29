//
//  CreateNewAccountViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/16/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class CreateNewAccountViewController: UIViewController {
    
    @IBOutlet weak var createAccountImageView: UIImageView!
    @IBOutlet weak var firstnameLabel: UITextField!
    @IBOutlet weak var lastnameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    private let alertHelper = AlertsHelper.createStaticInstance
    private let userHelper = UserHelper.createStaticInstance
    private var blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    
    func configureView(){
        ImageConfiguration().transformImage(createAccountImageView, shape: Shape.Circle(3.0, UIColor.whiteColor()))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createNewUser(sender: UIButton) {
        if let firstname = firstnameLabel.text , let lastname = lastnameLabel.text, let email = emailLabel.text, let password = passwordLabel.text{
            createAccountButton.enabled = false
            
            let user = BackendlessUser()
            
            user.email = email
            user.password = password
            
            let member = Member()
            member.username = email
            member.blUser = user
            member.firstname = firstname
            member.lastname = lastname
            
            blInstance.userService.registering(user, response: { (registeredUser : BackendlessUser!) -> () in
                let dataStore = self.blInstance.data.of(Member.ofClass())
                dataStore.save(member, response: { (savedObject : AnyObject!) -> Void in
                    self.blInstance.userService.login(email, password: password, response: { (loggedUser : BackendlessUser!) -> Void in
                        self.userHelper.processUserInformation(self)
                        }, error: { (error: Fault!) -> Void in
                            self.alertHelper.createSimpleNotificationAlert(self, title: "Error authenticating user", message: error.message, shouldDismissCurrentView: true, completion: nil)
                    })
                    
                    }, error: { (error: Fault!) -> Void in
                        self.alertHelper.createSimpleNotificationAlert(self, title: "Error creating user", message: error.message, shouldDismissCurrentView: false, completion: nil)
                        self.createAccountButton.enabled = true
                })
                }, error:{(error: Fault!) -> () in
                    self.alertHelper.createSimpleNotificationAlert(self, title: "Error creating user", message: error.message, shouldDismissCurrentView: false, completion: nil)
                    self.createAccountButton.enabled = true
            })
        }else{
            self.alertHelper.createSimpleNotificationAlert(self, title:"Missing Info", message: "To create a new user please provide firstname, lastname, email, password", shouldDismissCurrentView: false, completion: nil)
        }
    }
    
    @IBAction func cancelRegister(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
