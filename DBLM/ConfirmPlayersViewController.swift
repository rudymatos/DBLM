//
//  ConfirmPlayersViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/28/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class ConfirmPlayersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let usersName = ["Rudy Matos", "Ramon Mena", "Juan Cordero" , "Jonas Estepan" , "Alison Perez" , "Eudys Bautista"]
    var users = [User]()
    var filteredUsers = [User]()
    
    @IBOutlet weak var playerTableView: UITableView!
    
    class User {
        
        var name : String
        var confirmed: Bool
        init(name : String, confirmed:Bool){
            self.confirmed = confirmed
            self.name  = name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for firstname in usersName{
            let user = User(name: firstname, confirmed: false)
            users.append(user)
        }
        
        
        filteredUsers = users
        //        playerTableView.editing = true
        
        // Do any additional setup after loading the view.
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            filteredUsers = users
        }else{
            filteredUsers = users.filter({$0.name.uppercaseString.containsString(searchText.uppercaseString)})
        }
        playerTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var action = UITableViewRowAction()
        
        if filteredUsers[indexPath.row].confirmed {
            action = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Remove") { (action, indexPath) in
                self.filteredUsers[indexPath.row].confirmed = false
                self.playerTableView.editing = false
                self.playerTableView.reloadData()
                
            }
        }else{
            action = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Confirm") { (action, indexPath) in
                self.filteredUsers[indexPath.row].confirmed = true
                self.playerTableView.editing = false
                self.playerTableView.reloadData()
                
            }
        }
        
        
        
        let array = [action]
        
        return array
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("playerNameCell", forIndexPath: indexPath)
        cell.textLabel?.text = filteredUsers[indexPath.row].name
        
        if filteredUsers[indexPath.row].confirmed{
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
