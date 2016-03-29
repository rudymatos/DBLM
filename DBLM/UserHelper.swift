//
//  UserHelper.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 3/2/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation

class UserHelper{
    
    static let createStaticInstance = UserHelper()
    private let alertHelper = AlertsHelper.createStaticInstance
    private let blInstance = BackendlessHelper.createInstance.getBackendlessInstance()
    var currentMember : Member?
    
    
    func refreshMemberInfo(){
        let dataQuery = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.related = ["blUser", "leaguesRoles", "leaguesRoles.league", "leaguesRoles.league.lcode", "leaguesRoles.league.days"]
        dataQuery.whereClause = "blUser.objectId = \'\(blInstance.userService.currentUser.objectId)\'"
        dataQuery.queryOptions = queryOptions
        
        blInstance.data.of(Member.ofClass()).find(dataQuery, response: { (collection: BackendlessCollection!) -> Void in
            if collection.data != nil{
                if let member = collection.data[0] as? Member{
                    self.currentMember = member
                }
            }
            }, error: { (error: Fault!) -> Void in
                print("Error getting user. Please contact your system admin: UserHelper")
        })
        
    }
    var userInfoName : String?{
        if let firstname = currentMember?.firstname, let lastname = currentMember?.lastname{
            return firstname + " "+lastname
        }else{
            return "NOT AVAILABLE"
        }
    }
    
    
    func processUserInformation(view : UIViewController){
        if let currentUserID = blInstance.userService.currentUser.objectId{
            let dataQuery = BackendlessDataQuery()
            let queryOptions = QueryOptions()
            queryOptions.related = ["blUser", "leaguesRoles", "leaguesRoles.league","leaguesRoles.league.lcode","leaguesRoles.league.days"]
            dataQuery.whereClause = "blUser.objectId = \'\(currentUserID)\'"
            dataQuery.queryOptions = queryOptions
            blInstance.data.of(Member.ofClass()).find(dataQuery, response: { (members : BackendlessCollection!) -> Void in
                if(members.data.count > 1){
                    self.alertHelper.createSimpleNotificationAlert(view, title: "Error retrieving user", message: "More than an instance of Members had been found. Contact your Administrator", shouldDismissCurrentView: false, completion: nil)
                }else{
                    self.currentMember = members.data[0] as? Member
                    if self.currentMember?.leaguesRoles?.count > 0{
                        view.performSegueWithIdentifier("selectLeagueSegue", sender: nil)
                    }else{
                        view.performSegueWithIdentifier("noLeagueSegue", sender: nil)
                    }
                }
                }) { (error : Fault!) -> Void in
                    self.alertHelper.createSimpleNotificationAlert(view, title: "Error", message: "Error processing user information. Please contact admin.", shouldDismissCurrentView: false, completion: nil)
                    
            }
        }
    }
    
}