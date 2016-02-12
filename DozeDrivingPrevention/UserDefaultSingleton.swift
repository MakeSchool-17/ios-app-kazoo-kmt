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
    
    // Add alarm ID
    let keyForAlarmID = "Alarm"
    var currentAlarmID: Int? {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(currentAlarmID, forKey: keyForAlarmID)
        }
    }
    
    // Set counter how much time his/her eyes are closed
    var counter: Float
    
    private init() {
        //read reactionTime from NSUserDefault

        counter = 0

        // TODO
        // set initial alarm sound & add alarm ID
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("firstLaunchForSetting") {
            // Some Process will be here
//            UserDefaultSingleton.sharedUserDefault.currentAlarmID = 1005
            reactionTime = 1.0
            currentAlarmID = 1005
            NSUserDefaults.standardUserDefaults().setObject(reactionTime, forKey: keyForReactionTime)
            NSUserDefaults.standardUserDefaults().setObject(currentAlarmID, forKey: keyForAlarmID)

            print("pass 1.0 for reactionTime and 1005 for current AlarmID to default")

            // off the flag to know if it is first time to launch
            defaults.setBool(false, forKey: "firstLaunchForSetting")
        } else {
        
            reactionTime = NSUserDefaults.standardUserDefaults().objectForKey(keyForReactionTime) as! Float?
        
            // Add alarm sound
            currentAlarmID = NSUserDefaults.standardUserDefaults().objectForKey(keyForAlarmID) as! Int?
        }
    }
}