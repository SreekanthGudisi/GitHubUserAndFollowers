//
//  SharedInformation.swift
//  assignment
//
//  Created by Sreekanth Gudisi on 03/12/19.
//  Copyright © 2019 Manjunath. All rights reserved.
//

import Foundation

class SharedInformation {
    
    private static var sharedInformation : SharedInformation? = nil
    
    var userResponse : UserResponse? = nil
    var serachResponse :SerachResponse? = nil
    
    
    static func instance() -> SharedInformation {
        if (sharedInformation == nil) {
            sharedInformation = SharedInformation()
        }
        return sharedInformation!
    }
    
    private init() {
        // Fetch logged in keys
    }
}
