//
//  PlistHelper.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/17/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation

enum PlistFile : String{
    case Firebase = "firebase"
}

class PlistHelper{
    func getPlist(plist: PlistFile) -> NSDictionary?{
        let path = NSBundle.mainBundle().pathForResource(plist.rawValue, ofType: "plist")
        return NSDictionary(contentsOfFile: path!)
    }
}