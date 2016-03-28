//
//  LeagueOptionsViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/25/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class LeagueOptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var scheduleStatus: UILabel!
    @IBOutlet weak var leagueLogoImageView: UIImageView!
    @IBOutlet weak var currentUserLabel: UILabel!
    var currentLeagueRole : LeagueRole?
    private var currentLeague : League?
    private var allOptions = [[Option]]()
    private var sections = [String]()
    private var currentDay : Day?
    
    //MARK: HELPERS
    private let colorHelper = ColorHelper()
    private let commonHelper = CommonHelper()
    private let userHelper = UserHelper.createStaticInstance
    private let alertHelper = AlertsHelper.createStaticInstance
    private let blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        initData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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
            if currentLeague?.logoLarge == nil{
                leagueLogoImageView.image = UIImage(named: "imageNotFound")
                leagueLogoImageView.backgroundColor = ColorHelper().getRandomColor()
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
        if let currentUser = userHelper.currentMember{
            commonHelper.createLogoutConfirmationAlert(currentUser, currentView: self)
        }
        
    }
    
    func configureView(){
        
        self.automaticallyAdjustsScrollViewInsets = false
        ImageConfiguration().transformImage(leagueLogoImageView, shape: Shape.Square(0.5, UIColor.blackColor()))
        self.title = currentLeagueRole?.league?.name
        currentUserLabel.text = UserHelper.createStaticInstance.userInfoName
        
        if let league = currentLeagueRole?.league, let leagueObjectId = league.objectId{
            
            self.scheduleStatus.text = "No Schedule found for \(self.commonHelper.getCurrentDateString())"
            self.scheduleStatus.textColor = self.colorHelper.getAvailableOrUnavailableColor(.Neutral)
            
            let dataQuery = BackendlessDataQuery()
            dataQuery.whereClause = "objectId=\'\(leagueObjectId)\'"
            let queryOptions = QueryOptions()
            queryOptions.related = ["days", "lcode", "days.confirmedParticipants"]
            dataQuery.queryOptions = queryOptions
            
            
            blInstance.data.of(League.ofClass()).find(dataQuery, response: { (results : BackendlessCollection!) in
                if results.data.count > 0 {
                    self.currentLeague = results.data[0] as? League
                    if let days = self.currentLeague?.days{
                        if days.count > 0{
                            let dateFormatString = CommonHelper().getCurrentDateString()
                            for day in days{
                                if day.dateString == dateFormatString{
                                    self.currentDay = day
                                    if day.status == "OPEN"{
                                        self.scheduleStatus.text = "Schedule opened for \(self.commonHelper.getCurrentDateString())"
                                        self.scheduleStatus.textColor = self.colorHelper.getAvailableOrUnavailableColor(.Available)
                                    }else{
                                        self.scheduleStatus.text = "Schedule closed for \(self.commonHelper.getCurrentDateString())"
                                        self.scheduleStatus.textColor = self.colorHelper.getAvailableOrUnavailableColor(.Unavailable)
                                    }
                                }
                            }
                        }
                    }
                }
                }, error: { (error :Fault!) in
                    self.alertHelper.createSimpleNotificationAlert(self, title: "Error loading info", message: "Day info was not loaded correctly. Please contact administrator. Message \(error.message)", shouldDismissCurrentView: false, completion: nil)
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var currentCell : LeagueOptionTableViewCell
        currentCell = (tableView.dequeueReusableCellWithIdentifier("leagueOptionsCell", forIndexPath: indexPath) as? LeagueOptionTableViewCell)!
        currentCell.currentOption = allOptions[indexPath.section][indexPath.row]
        return currentCell
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
        if let identifier = segue.identifier{
            switch(identifier){
            case "leaveLeagueSegue":
                let joinLeagueVC = segue.destinationViewController as? JoinLeagueViewController
                joinLeagueVC?.league = currentLeague
            case "generateLCodeSegue":
                let generateLCodeVC = segue.destinationViewController as? GenerateLCodeViewController
                generateLCodeVC?.lCodeObjectId = currentLeague?.lcode.objectId
            case "createScheduleSegue":
                let createScheduleVC = segue.destinationViewController as? CreateScheduleViewController
                createScheduleVC?.currentLeague = currentLeague
            case "confirmAssistanceSegue":
                let confirmAssistance = segue.destinationViewController as? AssistanceConfirmationViewController
                confirmAssistance?.currentDay = currentDay
            default:
                print("no action for segue")
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let available = allOptions[indexPath.section][indexPath.row].available, let segueToPerform = allOptions[indexPath.section][indexPath.row].segueName{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            if available{
                if segueToPerform == "confirmAssistanceSegue"{
                    if currentDay?.status == "OPEN"{
                        performSegueWithIdentifier(segueToPerform, sender: nil)
                    }else{
                        alertHelper.createSimpleNotificationAlert(self, title: "Confirmation Error", message: "There are not schedule available for today", shouldDismissCurrentView: false, completion: nil)
                    }
                }else{
                    performSegueWithIdentifier(segueToPerform, sender: nil)
                }
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
