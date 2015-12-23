//
//  UserDefaultManager.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/21/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

import Foundation

class UserDefaultSingleton {

    static let sharedUserDefault = UserDefaultSingleton()
    
    // Set reaction time for adjustment
    let keyForReactionTime = "Reaction Time"
    var reactionTime: Float? {
        didSet {
            //write to NSUserDefault whenever reactionTime has changed
            NSUserDefaults.standardUserDefaults().setObject(reactionTime, forKey: keyForReactionTime)
        }
    }
    
    // Set array to count how much time his/her eyes are closed
//    var arrayForCount: [Bool] = []
    
    private init() {
        //read reactionTime from NSUserDefault
        reactionTime = NSUserDefaults.standardUserDefaults().objectForKey(keyForReactionTime) as! Float?
        
    }

}