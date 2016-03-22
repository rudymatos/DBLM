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
    var currentLeague : League?
    
    
    
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
        
        //        let formatter = NSDateFormatter()
        //        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //        let dateFormatString = formatter.stringFromDate(NSDate())
        //        
        //        if let leagueKey = currentLeague?.key {
        //            FireBaseHelper.createStaticInstance.LEAGUES_URL?.childByAppendingPath(leagueKey).childByAppendingPath("days").childByAppendingPath(dateFormatString).observeSingleEventOfType(.Value, withBlock: {snapshot in
        //                if snapshot.value is NSNull{
        //                    self.openCloseReOpenButton.titleLabel?.text = "CREATE DAY"
        //                    self.openCloseReOpenButton.backgroundColor = ColorHelper().getAvailableOrUnavailableColor(.Available)
        //                    self.openDayStatus.text = "No entries for current day"
        //                    self.openDayStatus.textColor = ColorHelper().getAvailableOrUnavailableColor(.Available)
        //                }else{
        //                    if let dayDictionary = snapshot.value as? Dictionary<String,AnyObject>, let status = dayDictionary["status"] as? String{
        //                        print("entering here!!!!!!")
        //                        if status == LeagueStatus.OPEN.rawValue{
        //                            print("entering here!!!!!!12312312")
        //                            self.openCloseReOpenButton.titleLabel?.text = "CLOSE DAY"
        //                            self.openCloseReOpenButton.backgroundColor = ColorHelper().getAvailableOrUnavailableColor(.Unavailable)
        //                            self.openDayStatus.text = "Currently playing on this day"
        //                            self.openDayStatus.textColor = ColorHelper().getAvailableOrUnavailableColor(.Available)
        //                            
        //                        }else if status == LeagueStatus.CLOSED.rawValue{
        //                            print("entering here!!!!!!sadfasd")
        //                            self.openCloseReOpenButton.titleLabel?.text = "REOPEN DAY"
        //                            self.openCloseReOpenButton.backgroundColor = ColorHelper().getAvailableOrUnavailableColor(.Available)
        //                            self.openDayStatus.text = "Day was already closed"
        //                            self.openDayStatus.textColor = ColorHelper().getAvailableOrUnavailableColor(.Unavailable)
        //                            
        //                        }
        //                    }
        //                }
        //            })
        //        }
        
        
    }
    
    @IBAction func takeActionOnDay(sender: UIButton) {
        
        //     s  let formatter = NSDateFormatter()
        //        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //        let dateFormatString = formatter.stringFromDate(NSDate())
        //        
        //        if let leagueKey = currentLeague?.key {
        //            FireBaseHelper.createStaticInstance.LEAGUES_URL?.childByAppendingPath(leagueKey).childByAppendingPath("days").childByAppendingPath(dateFormatString).observeSingleEventOfType(.Value, withBlock: {snapshot in
        //                var dayValues = Dictionary<String,AnyObject>()
        //                var message = ""
        //                if snapshot.value is NSNull{
        //                    dayValues = ["days" : [dateFormatString : ["status" : LeagueStatus.OPEN.rawValue]]]
        //                    message = "Schedule Created"
        //                }else{
        //                    if let dayDictionary = snapshot.value as? Dictionary<String,AnyObject>, let status = dayDictionary["status"] as? String{
        //                        if status == LeagueStatus.OPEN.rawValue{
        //                            dayValues =  ["status" : LeagueStatus.CLOSED.rawValue]
        //                            message = "Schedule Closed"
        //                        }else if status == LeagueStatus.CLOSED.rawValue{
        //                            dayValues =  ["status" : LeagueStatus.OPEN.rawValue]
        //                            message = "Schedule ReOpened"
        //                        }
        //                    }
        //                }
        //                FireBaseHelper.createStaticInstance.LEAGUES_URL?.childByAppendingPath(leagueKey).updateChildValues(dayValues)
        //                AlertsHelper().createSimpleNotificationAlert(self, title: message, message: message + " successfully for date :  \(dateFormatString)", shouldDismissCurrentView: false, completion: nil)
        //                self.configureView()
        //            })
        //        }
    }
    
}
