//
//  ColorHelper.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/28/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation
import UIKit

class ColorHelper{
    
    let colors : [UIColor] = [
        //        UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0), //teal color
        UIColor(red: 222/255.0, green: 171/255.0, blue: 66/255.0, alpha: 1.0), //yellow color
        UIColor(red: 223/255.0, green: 86/255.0, blue: 94/255.0, alpha: 1.0), //red color
        UIColor(red: 239/255.0, green: 130/255.0, blue: 100/255.0, alpha: 1.0), //orange color
        UIColor(red: 77/255.0, green: 75/255.0, blue: 82/255.0, alpha: 1.0), //dark color
        UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0), //purple color
        UIColor(red: 85/255.0, green: 176/255.0, blue: 112/255.0, alpha: 1.0), //green color
        UIColor(red: 227/255.0, green: 234/255.0, blue: 235/255.0, alpha: 1)
        //        UIColor(red: 34/255.0, green: 204/255.0, blue: 202/255.0, alpha: 1)
    ]
    
    func getRandomColor() -> UIColor{
        return colors[Int(arc4random_uniform(UInt32(colors.count)))];
    }
    
    
    enum ColorByAvailableness{
        case Available
        case Unavailable
        case Neutral
    }
    
    func getAvailableOrUnavailableColor(available : ColorByAvailableness) -> UIColor{
        switch available{
        case .Available:
            return UIColor(red: 34/255.0, green: 204/255.0, blue: 202/255.0, alpha: 1)
        case .Unavailable:
            return UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
        case .Neutral:
            return UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)
        }
    }
}

    