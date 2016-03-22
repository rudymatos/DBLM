//
//  GenerateLCodeViewController.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 3/3/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class GenerateLCodeViewController: UIViewController {
    
    private let blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    private let alertHelper = AlertsHelper.createStaticInstance
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeAvailablenessLabel: UILabel!
    var lCodeObjectId : String?{
        didSet{
            configureView()
        }
    }
    
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
        blInstance.data.of(LCode.ofClass()).findID(lCodeObjectId, response: { (currentObject : AnyObject!) -> Void in
            let lCode = currentObject as? LCode
            if let createdOn = lCode?.createdOn, let code = lCode?.code{
                let interval = NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: createdOn.timeIntervalSince1970))
                if (interval / 60) > 15{
                    self.codeAvailablenessLabel?.text = "Code is currently Unavailable"
                    self.codeAvailablenessLabel?.textColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
                }else{
                    self.codeAvailablenessLabel?.text = "Code is currently Available"
                    self.codeAvailablenessLabel?.textColor = UIColor(red: 34/255.0, green: 204/255.0, blue: 202/255.0, alpha: 1)
                }
                self.codeLabel?.text = code
            }
            },error: {(error : Fault!) -> Void in
                self.alertHelper.createSimpleNotificationAlert(self, title: "LCode Generator", message: "Error getting current LCode. Please try generating a new code", shouldDismissCurrentView: false, completion: nil)
        })
    }
    
    @IBAction func generateNewCode(sender: UIButton) {
        
        
        blInstance.data.of(LCode.ofClass()).findID(lCodeObjectId, response: { (currentObject : AnyObject!) -> Void in
            let currentLCode = currentObject as? LCode
            currentLCode?.code = CommonHelper().generateLCode()
            currentLCode?.createdOn = NSDate()
            self.blInstance.data.of(LCode.ofClass()).save(currentLCode, response: { (updatedObject : AnyObject!) -> Void in
                self.alertHelper.createSimpleNotificationAlert(self, title: "LCode Generator", message: "New LCode generated successfully", shouldDismissCurrentView: false, completion: nil)
                let lCode = updatedObject as? LCode
                self.lCodeObjectId = lCode?.objectId
                }, error: { (error:Fault!) -> Void in
                    self.alertHelper.createSimpleNotificationAlert(self, title: "LCode Generator", message: "Error generating LCode. Please try generating a new code", shouldDismissCurrentView: false, completion: nil)
            })
            }, error: { (error : Fault!) -> Void in
                self.alertHelper.createSimpleNotificationAlert(self, title: "LCode Generator", message: "Error generating LCode. Please try generating a new code", shouldDismissCurrentView: false, completion: nil)
        })
        
    }
    
}
