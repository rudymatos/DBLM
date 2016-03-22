//
//  NoTeamViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/19/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class NoLeagueViewController: UIViewController {
    
    @IBOutlet weak var joinLeagueButton: UIButton!
    @IBOutlet weak var joinNowImageView: UIImageView!
    @IBOutlet weak var newTeamImageView: UIImageView!
    @IBOutlet weak var tcodeText: UITextField!
    @IBOutlet weak var userLoggedIn: UILabel!
    private var currentLeague: League?
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var cancelPanel: UIView!
    var isComingFromSelectLeague = false
    private let alertHelper = AlertsHelper.createStaticInstance
    private let userHelper = UserHelper.createStaticInstance
    private let blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        ImageConfiguration().transformImage(joinNowImageView, shape: Shape.Square(3.0, UIColor.whiteColor()))
        ImageConfiguration().transformImage(newTeamImageView, shape: Shape.Square(3.0, UIColor.whiteColor()))
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tap)
        cancelPanel.hidden = true
        cancelLabel.hidden = true
        if isComingFromSelectLeague {
            cancelPanel.hidden = false
            cancelLabel.hidden = false
        }
        userLoggedIn.text = UserHelper.createStaticInstance.userInfoName
    }
    @IBAction func dismissCurrentView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissKeyboard(tap : UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutUser(sender: UITapGestureRecognizer) {
        if let currentUser = userHelper.currentMember{
            CommonHelper().createLogoutConfirmationAlert(currentUser, currentView: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            if identifier == "displayLeagueInfoSegue"{
                let joinTeamViewController = segue.destinationViewController as? JoinLeagueViewController
                joinTeamViewController?.league = currentLeague
            }
        }
    }
    
    @IBAction func joinTeamButton(sender: UIButton) {
        
        
        if let code = tcodeText.text{
            
            joinLeagueButton.enabled = false
            let dataQuery = BackendlessDataQuery()
            let queryOptions = QueryOptions()
            queryOptions.related = ["lcode"]
            dataQuery.whereClause = "lCode.code = \'\(code)\'"
            dataQuery.queryOptions = queryOptions
            
            //Making the request
            blInstance.data.of(League.ofClass()).find(dataQuery, response: { (results : BackendlessCollection!) -> Void in
                if results.data.count > 0{
                    print(results.data)
                    print(results.data[0])
                    if let league = results.data[0] as? League, let lCodeCreatedOn = league.lcode.createdOn{
                        let interval = NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: lCodeCreatedOn.timeIntervalSince1970))
                        if (interval / 60) > 15{
                            self.alertHelper.createSimpleNotificationAlert(self, title: "LCode Expired", message: "The supplied LCode is expired. Please contact your admin. He should provide a new LCode", shouldDismissCurrentView: false, completion: nil)
                            self.joinLeagueButton.enabled = true
                        }else{
                            self.currentLeague = league
                            self.performSegueWithIdentifier("displayLeagueInfoSegue", sender: nil)
                        }
                    }
                }else{
                    self.alertHelper.createSimpleNotificationAlert(self, title: "No Leagues Found", message: "There are currently no leagues using the specified LCODE.", shouldDismissCurrentView: false, completion: nil)
                    self.joinLeagueButton.enabled = true
                }
                }, error: { (error : Fault!) -> Void in
                    self.alertHelper.createSimpleNotificationAlert(self, title: "No Leagues Found", message: "There was an error trying to get the League with message : \(error.message)", shouldDismissCurrentView: false, completion: nil)
                    self.joinLeagueButton.enabled = true
                    
            })
        }
    }
}
