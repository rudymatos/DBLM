//
//  MemberListViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 3/28/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class MemberListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var memberListTableView: UITableView!
    var membersToShow :[Member]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    
    func configureView(){
        self.automaticallyAdjustsScrollViewInsets = false
        memberListTableView.rowHeight = 110
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("playerBasicInfoCell", forIndexPath: indexPath) as? MemberListTableViewCell{
            cell.member = membersToShow?[indexPath.row]
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (membersToShow?.count)!
    }
    
    
    
    
}
