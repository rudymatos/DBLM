//
//  User.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/28/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation



class Member : NSObject{
    
    var objectId: String?
    var blUser : BackendlessUser?
    var username : String?
    var mobilePhone : String?
    var largeProfilePicture : String?
    var thumbnailProfilePicture : String?
    var leaguesRoles : [LeagueRole]?
    
    
    
}