//
//  SelectTeamViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/23/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit
import Firebase

class SelectLeageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var leaguesTableView: UITableView!
    private var currentIndex = 1
    var member : Member?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureView(){
        self.automaticallyAdjustsScrollViewInsets = false
        leaguesTableView.rowHeight = 110
        currentIndex = 1
    }
    
    @IBAction func addLeague(sender: AnyObject) {
        performSegueWithIdentifier("addLeagueSegue", sender: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = leaguesTableView.dequeueReusableCellWithIdentifier("leagueCell", forIndexPath: indexPath) as? SelectLeagueTableViewCell{
            if let currentLeagueRole = member?.leaguesRoles?[indexPath.row], let league = currentLeagueRole.league{
                let colorHelper = ColorHelper()
                if league.logoThumbnail == nil{
                    if currentIndex % 2 == 0{
                        cell.leagueLogoImage.image = UIImage(named: "leagueLogo_1.png")
                    }else{
                        cell.leagueLogoImage.image = UIImage(named: "leagueLogo_2.png")
                    }
                    let color = colorHelper.getRandomColor()
                    league.backgroundColor = color
                    cell.leagueLogoImage.backgroundColor = color
                    cell.currentLeagueRole = currentLeagueRole
                    currentIndex++
                }            
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (member?.leaguesRoles?.count)!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier{
            if segueIdentifier == "addLeagueSegue"{
                if let noLeagueVC = segue.destinationViewController as? NoLeagueViewController{
                    noLeagueVC.isComingFromSelectLeague = true
                }
            }else if segueIdentifier == "showLeagueOptionsSegue"{
                if let leagueOptionsVC = segue.destinationViewController as? LeagueOptionsViewController{
                    leagueOptionsVC.currentLeagueRole = member?.leaguesRoles?[sender as! Int]
                }
            }
            
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("showLeagueOptionsSegue", sender: indexPath.row)
    }
    
    
}
