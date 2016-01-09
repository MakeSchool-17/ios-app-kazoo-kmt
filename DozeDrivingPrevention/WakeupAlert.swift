//
//  WakeupAlert.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/8/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

import UIKit
import AudioToolbox

let timeCountCloseBothEyes:Float = 0.13 // ２秒両目を閉じると警報を鳴らすようにしようとすると、２秒÷15フレーム＝1フレーム0.13を加算するようにする。
//let timeCountCloseSingleEye:Float = 0.06 // 両目を閉じているときの半分のスピードでカウントする
let timeCountCloseSingleEye:Float = 0.0 // 片目だけでのノイズが多い＆アラート状態から回復しにくいため、カウントゼロに変更
let timeCountOpenEyes:Float = 0.39 // 目を開けている間は両目を閉じている時の3倍早くカウントが回復するように設定（ノイズ防止のためにカウント自体は実行）


class WakeupAlert {
    
    func checkAlert (isFaceDetected: Bool, isEye1Detected: Bool, isEye2Detected: Bool) -> Bool {
        // 1. If closed both eyes, count twice. If closed one eye, count once. If opened eyes and count is not zero or negative, discount once. (need adjustment)
        if (isFaceDetected == true) {
            if (isEye1Detected == false && isEye2Detected == false) {
                // Both eyes are closed
                // FIXME ここのreactionTimeがしきい値となる。
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
            let soundIdRing:SystemSoundID = 1005  // alarm.caf
            AudioServicesPlaySystemSound(soundIdRing)
            return true
        }
        
        return false
    }
    
}
