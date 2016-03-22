//
//  ImageConfiguration.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/16/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation
import UIKit


enum Shape{
    
    case Square(Double,UIColor)
    case Circle(Double, UIColor)
    
}


class ImageConfiguration{
    
    func transformImage(image: UIImageView, shape : Shape){
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        switch shape{
        case .Circle(let borderWidth, let borderColor):
            setBorder(image, borderWidth: borderWidth, borderColor: borderColor)
        case .Square(let borderWidth, let borderColor):
            setBorder(image, borderWidth: borderWidth, borderColor: borderColor)
            image.layer.cornerRadius = 10.0
        }
    }
    
    private func setBorder(image: UIImageView , borderWidth : Double, borderColor : UIColor){
        image.layer.borderWidth = CGFloat(borderWidth)
        image.layer.borderColor = borderColor.CGColor
        
    }
    
    func setBlurToImageView(image: UIImageView){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = image.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        image.addSubview(blurEffectView)
        
    }
    
}