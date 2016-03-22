//
//  Option.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/14/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation
import UIKit

struct Option{
    
    let name : String?
    let image : UIImage?
    let description : String?
    let segueName : String?
    let available : Bool?
    
    init(configurationDictionary : NSDictionary){
        if let nameProperty = configurationDictionary["title"] as? String{
            name = nameProperty
        }else{
            name = nil
        }
        
        if let imagePath = configurationDictionary["image"] as? String{
            image = UIImage(named: imagePath)
        }else{
            image = nil
        }
        
        if let descriptionProperty = configurationDictionary["description"] as? String{
            description = descriptionProperty
        }else{
            description = nil
        }
        
        
        if let segueProperty = configurationDictionary["segue"] as? String{
            segueName = segueProperty
        }else{
            segueName = nil
        }
        
        if let availableProperty = configurationDictionary["available"] as? Bool{
            available = availableProperty
        }else{
            available = false
        }
        
    }
    
}