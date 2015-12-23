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
    
    func makeAlert (isFaceDetected: Bool, isEye1Detected: Bool, isEye2Detected: Bool) {
        // FIXME Arrayを使って一定時間分を格納するように変更する必要あり
        // FIXME Use singleton to make change for reaction time
        // Before checking eyes, face should be detected
        if (isFaceDetected == true) {
            if (isEye1Detected == false && isEye2Detected == false) {
                let soundIdRing:SystemSoundID = 1005  // alarm.caf
                AudioServicesPlaySystemSound(soundIdRing)
            }
        }
    }
    
}
