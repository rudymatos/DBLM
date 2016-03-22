//
//  JoinTeamViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/20/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class JoinLeagueViewController: UIViewController {
    
    
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueAddress: UILabel!
    @IBOutlet weak var leagueContact: UILabel!
    @IBOutlet weak var leaguePlayingSince: UILabel!
    @IBOutlet weak var totalMembers: UILabel!
    @IBOutlet weak var avgGoing: UILabel!
    @IBOutlet weak var injured: UILabel!
    private let userHelper = UserHelper.createStaticInstance
    private let blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    private let alertHelper = AlertsHelper.createStaticInstance
    var league : League!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: add AVG NUMBERS
    //TODO: add INJURED PLAYERS
    //TODO: add photo roller
    
    func configureView(){
        ImageConfiguration().transformImage(leagueImageView, shape: Shape.Circle(3.0, UIColor.whiteColor()))
        leagueName.text = league?.name
        leagueAddress.text = league?.address
        if let contact = league?.contact{
            leagueContact.text = contact
        }else{
            leagueContact.text = "Contact Info not provided"
        }
        
        if let membersCount = league?.members?.count{
            totalMembers.text = "\(membersCount)"
        }else{
            totalMembers.text = "0"
        }
        
        if let playingSince = league?.since{
            leaguePlayingSince.text = "Playing since : \(playingSince)"
        }else{
            let yearFormatter = NSDateFormatter()
            yearFormatter.dateFormat = "yyyy"
            leaguePlayingSince.text = "Playing since : \(yearFormatter.stringFromDate(NSDate()))"
        }
        
    }
    
    @IBAction func dismissCurrentView(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func joinLeague(sender: UIButton) {
        
        let leagueRole = LeagueRole()
        let currentUser = blInstance.userService.currentUser
        leagueRole.role = Role.REGULAR_MEMBER.rawValue
        leagueRole.league = league
        var leaguesRoles : [LeagueRole]
        
        if let leaguesRolesArrayFromUser = currentUser.getProperty("leaguesRoles") as? [LeagueRole]{
            leaguesRoles = leaguesRolesArrayFromUser
        }else{
            leaguesRoles = [LeagueRole]()
        }
        
        if league.members == nil{
            league.members = [LeagueRole]()
        }else{
            league.members?.append(leagueRole)
        }
        
        leaguesRoles.append(leagueRole)
        currentUser.setProperty("leaguesRoles", object: leaguesRoles)
        blInstance.userService.update(currentUser, response: { (updatedUser : BackendlessUser!) -> Void in
            self.blInstance.data.of(League.ofClass()).save(self.league, response: { (savedObject : AnyObject!) -> Void in
                self.performSegueWithIdentifier("selectLeagueSegue", sender: nil)
                }, error: {(error : Fault!) -> Void in
                    self.alertHelper.createSimpleNotificationAlert(self, title: "Error", message: "There was an error trying to add league with message : \(error.message)", shouldDismissCurrentView: false, completion: nil)
            })
            }, error:{ (error:Fault!) -> Void in
                self.alertHelper.createSimpleNotificationAlert(self, title: "Error", message: "There was an error trying to add user to league with message : \(error.message)", shouldDismissCurrentView: false, completion: nil)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let selectLeagueVC = segue.destinationViewController as? SelectLeageViewController{
            userHelper.refreshMemberInfo()
            selectLeagueVC.member = userHelper.currentMember
        }
    }
}
