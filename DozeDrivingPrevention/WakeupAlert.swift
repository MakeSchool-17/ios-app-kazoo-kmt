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
//class WakeupAlert: NSObject {
    
    func makeAlert (isFaceDetected: Bool, isEye1Detected: Bool, isEye2Detected: Bool) {
        // FIXME Arrayを使って一定時間分を格納するように変更する必要あり
        // FIXME Setting ViewからのDelegateで、反応時間を変更できるようにする
        // FIXME アラームを選べるようにすることもできる？
        // Before checking eyes, face should be detected
        if (isFaceDetected == true) {
            if (isEye1Detected == false && isEye2Detected == false) {
                let soundIdRing:SystemSoundID = 1005  // alarm.caf
                AudioServicesPlaySystemSound(soundIdRing)
            }
        }
    }
}
