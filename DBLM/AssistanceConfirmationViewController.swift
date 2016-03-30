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
    private let commonHelper = CommonHelper.createStaticInstance
    var leagueDay : (currentDay : Day, currentLeague : League)?{
        didSet{
            configureView()
        }
    }
    
    private var currentDayString = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "confirmedParticipantsSegue"{
            if let membersConfirmed =  leagueDay?.currentDay.confirmedParticipants{
                if let mvc = segue.destinationViewController as? MemberListViewController{
                    let leagueMembersToShow = (currentLeague : (leagueDay?.currentLeague)!, currentMembersToShow : membersConfirmed)
                    mvc.leagueMembersToShow = leagueMembersToShow
                }
            }
        }
    }
    
    @IBAction func showMembers(sender: UITapGestureRecognizer) {
        if let membersConfirmed =  leagueDay?.currentDay.confirmedParticipants{
            if membersConfirmed.count > 0{
                performSegueWithIdentifier("confirmedParticipantsSegue", sender: nil)
            }else{
                alertHelper.createSimpleNotificationAlert(self, title: "No Participants", message: "No members has confirmed participation yet", shouldDismissCurrentView: false, completion: nil)
            }
        }
    }
    
    func configureView(){
        memberCount?.text = "No participants hasn't confirmed yet"
        if let membersConfirmed =  leagueDay?.currentDay.confirmedParticipants{
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
        
        if let dateString = leagueDay?.currentDay.dateString{
            currentDayString = dateString
        }
        
        let newText = instructionsText?.text?.stringByReplacingOccurrencesOfString("<next_date>", withString: currentDayString)
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
        let alert = UIAlertController(title: "Confirm Cancellation", message: "Are you sure you to cancel your assistance for \(currentDayString)?", preferredStyle: .Alert)
        
        let cancelButton = UIAlertAction(title: "No", style: .Cancel) {(alert) -> Void in }
        let confirm = UIAlertAction(title: "Yes, I'm sure", style: .Default) { (alert) -> Void in
            if let currentMember = self.userHelper.currentMember{
                if let memberIndex = self.leagueDay?.currentDay.confirmedParticipants?.indexOf({$0.username == currentMember.username}){
                    self.leagueDay?.currentDay.confirmedParticipants?.removeAtIndex(memberIndex)
                    self.blInstance.data.of(Day.ofClass()).save(self.leagueDay?.currentDay, response: { (result : AnyObject!) in
                        self.alertHelper.createNotificationInNavigationViewController(self, title: "Cancelled", message: "Your confirmation for \(self.currentDayString) was successfully removed", shouldDismissCurrentView: true)
                        }, error: { (error : Fault!) in
                            self.alertHelper.createSimpleNotificationAlert(self, title: "Cancelation Error", message: "There was an error trying to cancel your assistance on \(self.currentDayString) with message : \(error.message)", shouldDismissCurrentView: false, completion: nil)
                    })
                }
            }else{
                self.alertHelper.createSimpleNotificationAlert(self, title: "Cancelation Error", message: "There was an error trying to cancel your assistance on \(self.currentDayString). Please contact administrator", shouldDismissCurrentView: false, completion: nil)
            }
        }
        alert.addAction(cancelButton)
        alert.addAction(confirm)
        self.presentViewController(alert, animated: true) {
            
        }
        
    }
    
    @IBAction func confirmAssistance(sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirm Participation", message: "Are you sure you are going to be able to assist to the league on \(currentDayString)?", preferredStyle: .Alert)
        
        let cancelButton = UIAlertAction(title: "No", style: .Cancel) {(alert) -> Void in }
        let confirm = UIAlertAction(title: "Yes, I'm sure", style: .Default) { (alert) -> Void in
            if let currentMember = self.userHelper.currentMember{
                if self.leagueDay?.currentDay.confirmedParticipants == nil{
                    self.leagueDay?.currentDay.confirmedParticipants = [Member]()
                }
                self.leagueDay?.currentDay.confirmedParticipants?.append(currentMember)
                self.blInstance.data.of(Day.ofClass()).save(self.leagueDay?.currentDay, response: { (result : AnyObject!) in
                    self.alertHelper.createNotificationInNavigationViewController(self, title: "Confirmed", message: "Successfully confirmation on \(self.currentDayString)", shouldDismissCurrentView: true)
                    }, error: { (error : Fault!) in
                        self.alertHelper.createSimpleNotificationAlert(self, title: "Confirmation Error", message: "There was an error trying to confirm your assistance on \(self.currentDayString) with message : \(error.message)", shouldDismissCurrentView: false, completion: nil)
                })
            }else{
                self.alertHelper.createSimpleNotificationAlert(self, title: "Confirmation Error", message: "There was an error trying to confirm your assistance on \(self.currentDayString). Please contact administrator", shouldDismissCurrentView: false, completion: nil)
            }
        }
        alert.addAction(cancelButton)
        alert.addAction(confirm)
        self.presentViewController(alert, animated: true) {
            
        }
    }
}
