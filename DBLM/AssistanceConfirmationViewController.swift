//
//  AssistanceConfirmationViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/14/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class AssistanceConfirmationViewController: UIViewController {
    
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var notGoingButton: UIButton!
    @IBOutlet weak var instructionsText: UILabel!
    @IBOutlet weak var memberCount: UILabel!
    private let alertHelper = AlertsHelper.createStaticInstance
    private let blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    private let userHelper = UserHelper.createStaticInstance
    var currentDay : Day!{
        didSet{
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showMembers(sender: UITapGestureRecognizer) {
        print("here")
        alertHelper.createSimpleNotificationAlert(self, title: "Showing users", message: "showing users", shouldDismissCurrentView: false, completion: nil)
    }
    
    func configureView(){
        memberCount?.text = "No participants hasn't confirmed yet"
        if let membersConfirmed =  currentDay.confirmedParticipants{
            memberCount?.text = "\(membersConfirmed.count) Participants Confirmed"
            if let currentMember = self.userHelper.currentMember{
                if membersConfirmed.contains({$0.username == currentMember.username}){
                    goingButton?.hidden = true
                    notGoingButton?.hidden = false
                }else{
                    goingButton?.hidden = false
                    notGoingButton?.hidden = true
                }
            }
        }
        let newText = instructionsText?.text?.stringByReplacingOccurrencesOfString("<next_date>", withString: (currentDay?.dateString!)!)
        instructionsText?.text = newText
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
    
    @IBAction func cancelConfirmation(sender: UIButton) {
        let alert = UIAlertController(title: "Confirm Cancellation", message: "Are you sure you to cancel your assistance for \(currentDay.dateString!)?", preferredStyle: .Alert)
        
        let cancelButton = UIAlertAction(title: "No", style: .Cancel) {(alert) -> Void in }
        let confirm = UIAlertAction(title: "Yes, I'm sure", style: .Default) { (alert) -> Void in
            if let currentMember = self.userHelper.currentMember{
                if let memberIndex = self.currentDay.confirmedParticipants?.indexOf({$0.username == currentMember.username}){
                    self.currentDay.confirmedParticipants?.removeAtIndex(memberIndex)
                    self.blInstance.data.of(Day.ofClass()).save(self.currentDay, response: { (result : AnyObject!) in
                        self.alertHelper.createNotificationInNavigationViewController(self, title: "Cancelled", message: "Your confirmation for \(self.currentDay.dateString!) was successfully removed", shouldDismissCurrentView: true)
                        }, error: { (error : Fault!) in
                            self.alertHelper.createSimpleNotificationAlert(self, title: "Cancelation Error", message: "There was an error trying to cancel your assistance on \(self.currentDay.dateString!) with message : \(error.message)", shouldDismissCurrentView: false, completion: nil)
                    })
                }
            }else{
                self.alertHelper.createSimpleNotificationAlert(self, title: "Cancelation Error", message: "There was an error trying to cancel your assistance on \(self.currentDay.dateString!). Please contact administrator", shouldDismissCurrentView: false, completion: nil)
            }
        }
        alert.addAction(cancelButton)
        alert.addAction(confirm)
        self.presentViewController(alert, animated: true) {
            
        }
        
    }
    
    @IBAction func confirmAssistance(sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirm Participation", message: "Are you sure you are going to be able to assist to the league on \(currentDay.dateString!)?", preferredStyle: .Alert)
        
        let cancelButton = UIAlertAction(title: "No", style: .Cancel) {(alert) -> Void in }
        let confirm = UIAlertAction(title: "Yes, I'm sure", style: .Default) { (alert) -> Void in
            if let currentMember = self.userHelper.currentMember{
                if self.currentDay.confirmedParticipants == nil{
                    self.currentDay.confirmedParticipants = [Member]()
                }
                self.currentDay.confirmedParticipants?.append(currentMember)
                self.blInstance.data.of(Day.ofClass()).save(self.currentDay, response: { (result : AnyObject!) in
                    self.alertHelper.createNotificationInNavigationViewController(self, title: "Confirmed", message: "Successfully confirmation on \(self.currentDay.dateString!)", shouldDismissCurrentView: true)
                    }, error: { (error : Fault!) in
                        self.alertHelper.createSimpleNotificationAlert(self, title: "Confirmation Error", message: "There was an error trying to confirm your assistance on \(self.currentDay.dateString!) with message : \(error.message)", shouldDismissCurrentView: false, completion: nil)
                })
            }else{
                self.alertHelper.createSimpleNotificationAlert(self, title: "Confirmation Error", message: "There was an error trying to confirm your assistance on \(self.currentDay.dateString!). Please contact administrator", shouldDismissCurrentView: false, completion: nil)
            }
        }
        alert.addAction(cancelButton)
        alert.addAction(confirm)
        self.presentViewController(alert, animated: true) {
            
        }
    }
}
