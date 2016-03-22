//
//  CreateNewTeamViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/19/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class CreateNewLeagueViewController: UIViewController {
    
    
    @IBOutlet weak var createLeagueActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var createLeagueButton: UIButton!
    @IBOutlet weak var createNewTeamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UITextField!
    @IBOutlet weak var teamAddressLabel: UITextField!
    @IBOutlet weak var playOnLabel: UITextField!
    private let alertHelper = AlertsHelper.createStaticInstance
    private let userHelper = UserHelper.createStaticInstance
    private let blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func configureView(){
        ImageConfiguration().transformImage(createNewTeamImageView, shape: Shape.Circle(3.0, UIColor.whiteColor()))
    }
    
    @IBAction func createNewLeague(sender: UIButton) {
        
        if teamNameLabel.text != "" && teamAddressLabel.text != "" && playOnLabel.text != "" {
            
            createLeagueButton.enabled = false
            createLeagueActivityIndicator.startAnimating()
            
            
            let name  = teamNameLabel.text!
            let address = teamAddressLabel.text!
            let playOn = playOnLabel.text!
            let blUser = blInstance.userService.currentUser
            
            let newLeague = League()
            newLeague.name = name
            newLeague.address = address
            newLeague.playOn = playOn
            newLeague.createdBy = blUser
            let lcode = LCode()
            lcode.code = CommonHelper().generateLCode()
            lcode.createdOn = NSDate()
            newLeague.lcode = lcode
            
            
            let dataQuery = BackendlessDataQuery()
            dataQuery.whereClause = "blUser.objectId = \'\(blInstance.userService.currentUser.objectId)\'"
            
            
            blInstance.data.of(Member.ofClass()).find(dataQuery, response: { (collection: BackendlessCollection!) -> Void in
                if collection.data != nil{
                    if let member = collection.data[0] as? Member{
                        let leagueRole = LeagueRole()
                        leagueRole.league = newLeague
                        leagueRole.role = Role.ADMIN.rawValue
                        if member.leaguesRoles == nil{
                            member.leaguesRoles = [LeagueRole]()
                        }
                        member.leaguesRoles?.append(leagueRole)
                        self.blInstance.data.of(Member.ofClass()).save(member, response: { (updatedMember : AnyObject!) -> Void in
                            self.performSegueWithIdentifier("selectLeagueSegue", sender: nil)
                            }, error: { (error:Fault!) -> Void in
                                self.alertHelper.createSimpleNotificationAlert(self, title: "Error creating League", message: "There was an errro trying to create a new league with error \(error.message)", shouldDismissCurrentView: false, completion: nil)
                                
                                self.createLeagueButton.enabled = true
                                self.createLeagueActivityIndicator.stopAnimating()
                                
                        })
                        
                    }
                }
                }, error: { (error: Fault!) -> Void in
                    self.alertHelper.createSimpleNotificationAlert(self, title: "Error creating League", message: "There was an errro trying to create a new league with error \(error.message)", shouldDismissCurrentView: false, completion: nil)
                    
                    self.createLeagueButton.enabled = true
                    self.createLeagueActivityIndicator.stopAnimating()
            })
        }else{
            self.alertHelper.createSimpleNotificationAlert(self, title:"Error creating League" , message: "Make sure you provide all the required information", shouldDismissCurrentView: false, completion: nil)
            
            createLeagueButton.enabled = true
            createLeagueActivityIndicator.stopAnimating()
        }
    }
    
    
    
    @IBAction func goBackToNoTeamPage(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
