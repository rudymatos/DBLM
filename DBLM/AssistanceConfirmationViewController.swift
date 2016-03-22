//
//  AssistanceConfirmationViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/14/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class AssistanceConfirmationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func confirmAssistance(sender: UIButton) {
        let alert = UIAlertController(title: "Confirm Participation", message: "Are you sure you are going to be able to assist to the league on <next_date>?", preferredStyle: .Alert)
        
        let cancelButton = UIAlertAction(title: "No", style: .Destructive) {(alert) -> Void in }
        let confirm = UIAlertAction(title: "Yes, I'm sure", style: .Default) { (alert) -> Void in
            print("yes nigga I'm going")
        }
        alert.addAction(cancelButton)
        alert.addAction(confirm)
        self.presentViewController(alert, animated: true) {
            
        }
    }
}
