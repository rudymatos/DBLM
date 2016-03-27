//
//  FireBaseHelper.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/17/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation

class FireBaseHelper{
    
//    static let createStaticInstance  = FireBaseHelper()
//    
//    private let plistHelper = PlistHelper()
//    private var firebaseDictionary :  NSDictionary?
//    
//    
//    var LEAGUES_URL : Firebase?{
//        get{
//            if let baseURL = firebaseDictionary?.objectForKey("leagueURL") as? String{
//                let firebaseRootURL = Firebase(url: baseURL)
//                return firebaseRootURL
//            }else{
//                return nil
//            }
//        }
//    }
//    
//    
//    
//    var BASE_URL : Firebase?{
//        get{
//            if let baseURL = firebaseDictionary?.objectForKey("baseURL") as? String{
//                let firebaseRootURL = Firebase(url: baseURL)
//                return firebaseRootURL
//            }else{
//                return nil
//            }
//        }
//    }
//    
//    var USERS_URL : Firebase?{
//        get{
//            if let usersURL = firebaseDictionary?.objectForKey("usersURL") as? String{
//                let firebaseUsers = Firebase(url: usersURL)
//                return firebaseUsers
//            }else{
//                return nil
//            }
//        }
//    }
//    
//    
//    func currentUser() -> Firebase?{
//        let uid = NSUserDefaults.standardUserDefaults().objectForKey("uid") as? String
//        if let currentUserURL = USERS_URL?.childByAppendingPath(uid){
//            return currentUserURL
//        }else{
//            return nil
//        }
//        
//    }
//    
//    private init(){
//        firebaseDictionary = plistHelper.getPlist(.Firebase)
//    }
    
}