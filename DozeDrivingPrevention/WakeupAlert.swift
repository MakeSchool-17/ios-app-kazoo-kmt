//
//  WakeupAlert.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/8/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

import UIKit
import AudioToolbox

class WakeupAlert {
    
    func checkAlert (isFaceDetected: Bool, isEye1Detected: Bool, isEye2Detected: Bool) {
        // 1. If closed both eyes, count twice. If closed one eye, count once. If opened eyes and count is not zero or negative, discount once. (need adjustment)
        if (isFaceDetected == true) {
            if (isEye1Detected == false && isEye2Detected == false) {
                // Both eyes are closed
                // FIXME ここのreactionTimeがしきい値となる。
                // ２秒両目を閉じると警報を鳴らすようにしようとすると、２秒÷15フレーム＝1フレーム0.13を加算するようにする。片目の場合はその半分の0.06を加算するようにする
                if (UserDefaultSingleton.sharedUserDefault.counter < UserDefaultSingleton.sharedUserDefault.reactionTime) {
                    UserDefaultSingleton.sharedUserDefault.counter += 0.13
                }
                
            } else if (isEye1Detected == false || isEye2Detected == false) {
                if (UserDefaultSingleton.sharedUserDefault.counter < UserDefaultSingleton.sharedUserDefault.reactionTime) {
                    UserDefaultSingleton.sharedUserDefault.counter += 0.06
                }
            } else {
                if (UserDefaultSingleton.sharedUserDefault.counter >= 0.26) {
                    UserDefaultSingleton.sharedUserDefault.counter -= 0.26
                } else if (UserDefaultSingleton.sharedUserDefault.counter < 0.26) {
                UserDefaultSingleton.sharedUserDefault.counter = 0
                }
            }
        } else {
            if (UserDefaultSingleton.sharedUserDefault.counter >= 0.26) {
                UserDefaultSingleton.sharedUserDefault.counter -= 0.26
            } else if (UserDefaultSingleton.sharedUserDefault.counter < 0.26) {
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
            let soundIdRing:SystemSoundID = 1005  // alarm.caf
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    
}
