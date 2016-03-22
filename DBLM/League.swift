//
//  Team.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/19/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation
import UIKit

class League: NSObject{
    
    var name : String?
    var logoLarge : String?
    var logoThumbnail : String?
    var address : String?
    var playOn : String?
    var contact : String?
    var members : [LeagueRole]?
    var since  : Int?
    var createdBy : BackendlessUser?
    var lcode : LCode!
    var backgroundColor : UIColor?
    
}


