//
//  CreateScheduleViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 3/5/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class CreateScheduleViewController: UIViewController {
    
    
    @IBOutlet weak var openDayStatus: UILabel!
    @IBOutlet weak var openCloseReOpenButton: UIButton!
    var currentLeague : League!
    private var currentDay : Day?
    private let alertHelper = AlertsHelper.createStaticInstance
    private let blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    private let userHelper = UserHelper.createStaticInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureView(){
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "dateString =\'\(CommonHelper().getCurrentDateString())\'"
        
        
        blInstance.data.of(Day.ofClass()).find(dataQuery, response: { (results : BackendlessCollection!) -> Void in
            if  results.data.count > 0{
                self.currentDay = results.data[0] as? Day
                if self.currentDay?.status == "OPEN" {
                    self.openCloseReOpenButton.titleLabel?.text = "CLOSE DAY"
                    self.openCloseReOpenButton.backgroundColor = ColorHelper().getAvailableOrUnavailableColor(.Unavailable)
                    self.openDayStatus.text = "Currently playing on this day"
                    self.openDayStatus.textColor = ColorHelper().getAvailableOrUnavailableColor(.Available)
                }else{
                    self.openCloseReOpenButton.titleLabel?.text = "REOPEN DAY"
                    self.openCloseReOpenButton.backgroundColor = ColorHelper().getAvailableOrUnavailableColor(.Available)
                    self.openDayStatus.text = "Day was already closed"
                    self.openDayStatus.textColor = ColorHelper().getAvailableOrUnavailableColor(.Unavailable)
                }
            }else{
                self.initialStateForDate()
            }
            }) { (error: Fault!) -> Void in
                print("something happens")
                self.initialStateForDate()
        }
        
        
    }
    
    private func initialStateForDate(){
        self.openCloseReOpenButton.titleLabel?.text = "CREATE DAY"
        self.openCloseReOpenButton.backgroundColor = ColorHelper().getAvailableOrUnavailableColor(.Available)
        self.openDayStatus.text = "No entries for current day"
        self.openDayStatus.textColor = ColorHelper().getAvailableOrUnavailableColor(.Available)
    }
    
    
    @IBAction func takeActionOnDay(sender: UIButton) {
        
        
        if currentDay == nil{
            let currentDay = Day()
            
            currentDay.dateString = CommonHelper().getCurrentDateString()
            currentDay.status = "OPEN"
            currentDay.possibleParticipants = nil
            currentDay.confirmedParticipants = nil
            
            if self.currentLeague.days == nil{
                self.currentLeague.days = [Day]()
            }
            
            self.currentLeague.days?.append(currentDay)
            self.blInstance.data.of(League.ofClass()).save(self.currentLeague, response: { (result : AnyObject!) -> Void in
                self.alertHelper.createNotificationInNavigationViewController(self, title: "Day Created", message: "Day schedule created succesfully", shouldDismissCurrentView: true)
            }) { (error : Fault!) -> Void in
                print(error.message)
                self.alertHelper.createSimpleNotificationAlert(self, title: "Error creating Schedule", message: error.message, shouldDismissCurrentView: false, completion: nil)
            }
            

            
        }else if let status = currentDay?.status{
            switch(status){
            case "OPEN":
                currentDay?.status = "CLOSED"
                self.blInstance.data.of(Day.ofClass()).save(currentDay, response: { (result : AnyObject!) -> Void in
                    self.alertHelper.createNotificationInNavigationViewController(self, title: "Day Closed", message: "Day closed succesfully", shouldDismissCurrentView: true)
                }) { (error : Fault!) -> Void in
                    self.alertHelper.createSimpleNotificationAlert(self, title: "Error creating Schedule", message: error.message, shouldDismissCurrentView: false, completion: nil)
                }
                
            case "CLOSED":
                currentDay?.status = "OPEN"
                self.blInstance.data.of(Day.ofClass()).save(currentDay, response: { (result : AnyObject!) -> Void in
                    self.alertHelper.createNotificationInNavigationViewController(self, title: "Day Reopned", message: "Day reopened succesfully", shouldDismissCurrentView: true)
                }) { (error : Fault!) -> Void in
                    self.alertHelper.createSimpleNotificationAlert(self, title: "Error creating Schedule", message: error.message, shouldDismissCurrentView: false, completion: nil)
                }

            default :
                self.alertHelper.createSimpleNotificationAlert(self, title: "Error creating Schedule", message: "Invalid Day Status", shouldDismissCurrentView: false, completion: nil)
            }
            
        }
        
    }
    
}
