//
//  NavBarConfigurator.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/14/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation
import UIKit

class NavBarConfigurator{

    func navBarTitleAndColor() -> [String : AnyObject]?{
        let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0)
        let navBarAttributesDictionary : [String : AnyObject]? = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: navBarFont!]
        return navBarAttributesDictionary
    }

}