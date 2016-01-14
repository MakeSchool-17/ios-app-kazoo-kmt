//
//  WakeupAlert.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/8/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

import UIKit
import AudioToolbox

let timeCountCloseBothEyes:Float = 0.13 // FIXME: counter per 1 frame (Assume to make alert when you close your eyes for 2 seconds, 2sec / 15 frames = 0.13
let timeCountCloseSingleEye:Float = 0.0 // FIXME: Can be half count, if you close an eye. Currently, no count because of noise
let timeCountOpenEyes:Float = 0.39 // FIXME: When you open both eyes, count back 3rd times as both eyes' closing count

// Declare preset alarm's title and ID
let alarmTitle: NSArray = ["Alarm 1", "Alarm 2", "Alarm 3"]
let alarmID: NSArray = [1005, 1256, 1151]


class WakeupAlert {
    func checkAlert (isFaceDetected: Bool, isEye1Detected: Bool, isEye2Detected: Bool) -> Bool {
        // 1. If closed both eyes, count twice. If closed one eye, count once. If opened eyes and count is not zero or negative, discount once. (need adjustment)
        if (isFaceDetected == true) {
            if (isEye1Detected == false && isEye2Detected == false) {
                // Both eyes are closed
                if (UserDefaultSingleton.sharedUserDefault.counter < UserDefaultSingleton.sharedUserDefault.reactionTime) {
                    UserDefaultSingleton.sharedUserDefault.counter += timeCountCloseBothEyes
                }
                
            } else if (isEye1Detected == false || isEye2Detected == false) {
                if (UserDefaultSingleton.sharedUserDefault.counter < UserDefaultSingleton.sharedUserDefault.reactionTime) {
                    UserDefaultSingleton.sharedUserDefault.counter += timeCountCloseSingleEye
                }
            } else {
                if (UserDefaultSingleton.sharedUserDefault.counter >= timeCountOpenEyes) {
                    UserDefaultSingleton.sharedUserDefault.counter -= timeCountOpenEyes
                } else if (UserDefaultSingleton.sharedUserDefault.counter < timeCountOpenEyes) {
                UserDefaultSingleton.sharedUserDefault.counter = 0
                }
            }
        } else {
            if (UserDefaultSingleton.sharedUserDefault.counter >= timeCountOpenEyes) {
                UserDefaultSingleton.sharedUserDefault.counter -= timeCountOpenEyes
            } else if (UserDefaultSingleton.sharedUserDefault.counter < timeCountOpenEyes) {
                UserDefaultSingleton.sharedUserDefault.counter = 0
            }
        }
        
        print (UserDefaultSingleton.sharedUserDefault.counter)
        // 2. If count surpasses the number which is setted in UserDefaultSingleton, then make alert.
        /*
        UserDefaultSingleton.sharedUserDefault.arrayForCount += 1
        if (UserDefaultSingleton.sharedUserDefault.arrayForCount > 10) {
        }
        */
        if (UserDefaultSingleton.sharedUserDefault.counter > UserDefaultSingleton.sharedUserDefault.reactionTime) {
//            let soundIdRing:SystemSoundID = 1005  // alarm.caf
            let soundIdRing:SystemSoundID = UInt32(UserDefaultSingleton.sharedUserDefault.currentAlarmID!) // alarm.caf
            AudioServicesPlaySystemSound(soundIdRing)
            return true
        }
        
        return false
    }
    
}
