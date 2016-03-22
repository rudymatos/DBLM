//
//  BackendlessHelper.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 3/10/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import Foundation

class BackendlessHelper{
    
    static let createInstance = BackendlessHelper()
    
    func getBackendlessInstance() -> Backendless{
        return Backendless.sharedInstance()
    }
    
}