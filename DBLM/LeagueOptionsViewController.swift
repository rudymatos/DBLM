//
//  LeagueOptionsViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/25/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class LeagueOptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var leagueLogoImageView: UIImageView!
    @IBOutlet weak var currentUserLabel: UILabel!
    var currentLeagueRole : LeagueRole?
    private var allOptions = [[Option]]()
    private var sections = [String]()
    private let alertHelper = AlertsHelper.createStaticInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        initData()
    }
    
    func initData(){
        if let role = currentLeagueRole?.role{
            var currentDefaultRole = Role.REGULAR_MEMBER
            sections = ["Member"]
            if role == Role.ADMIN.rawValue{
                currentDefaultRole = Role.ADMIN
                sections = ["Member", "Admin"]
            }
            processOptions(currentDefaultRole)
            if currentLeagueRole?.league?.logoLarge == nil{
                leagueLogoImageView.image = UIImage(named: "imageNotFound")
                leagueLogoImageView.backgroundColor = currentLeagueRole?.league?.backgroundColor
                leagueLogoImageView.contentMode = UIViewContentMode.Center
            }else{
                leagueLogoImageView.contentMode = UIViewContentMode.ScaleAspectFit
            }
        }
    }
    
    
    func processOptions(role : Role){
        allOptions = [[Option]]()
        if let leagueMenuItemPath = NSBundle.mainBundle().pathForResource("leagueMenuItems", ofType: "plist"),let plistDictionary = NSDictionary(contentsOfFile: leagueMenuItemPath) {
            func processPListFile(optionName : String){
                var options = [Option]()
                if let items = plistDictionary[optionName] as? Dictionary<String,AnyObject>{
                    for key in items.keys{
                        let currentOption = Option(configurationDictionary: (items[key] as? Dictionary<String, AnyObject>)!)
                        options.append(currentOption)
                    }
                    allOptions.append(options)
                }
            }
            processPListFile("member")
            if role == Role.ADMIN {
                processPListFile("admin")
            }
            
        }
        
    }
    
    
    
    @IBAction func logout(sender: UITapGestureRecognizer) {
        if let currentUser = FireBaseHelper.createStaticInstance.currentUser(){
            CommonHelper().createLogoutConfirmationAlert(currentUser, currentView: self)
        }
    }
    
    
    
    
    func configureView(){
        self.automaticallyAdjustsScrollViewInsets = false
        ImageConfiguration().transformImage(leagueLogoImageView, shape: Shape.Square(0.5, UIColor.blackColor()))
        self.title = currentLeagueRole?.league?.name
        currentUserLabel.text = UserHelper.createStaticInstance.userInfoName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("leagueOptions", forIndexPath: indexPath) as? LeagueOptionTableViewCell{
            cell.currentOption = allOptions[indexPath.section][indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allOptions[section].count
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = UIColor(red: 37/255.0, green: 195/255.0, blue: 190/255.0, alpha: 1)
        header?.textLabel?.font = UIFont(name: "Helvetica-Neue-Thin", size: 16)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "leaveLeagueSegue"{
            let joinLeagueVC = segue.destinationViewController as? JoinLeagueViewController
            joinLeagueVC?.league = currentLeagueRole?.league
        }else if segue.identifier == "generateLCodeSegue" {
            let generateLCodeVC = segue.destinationViewController as? GenerateLCodeViewController
            generateLCodeVC?.lCodeObjectId = currentLeagueRole?.league?.lcode.objectId
        }else if segue.identifier == "createScheduleSegue" {
            let createScheduleVC = segue.destinationViewController as? CreateScheduleViewController
            createScheduleVC?.currentLeague = currentLeagueRole?.league
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let available = allOptions[indexPath.section][indexPath.row].available, let segueToPerform = allOptions[indexPath.section][indexPath.row].segueName{
            if available{
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                performSegueWithIdentifier(segueToPerform, sender: nil)
            }else{
                alertHelper.createSimpleNotificationAlert(self, title: "Not Available", message: "Option is not currently available", shouldDismissCurrentView: false, completion: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    
}
