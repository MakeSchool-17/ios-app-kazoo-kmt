//
//  SettingViewController.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/1/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        label.text = "\(sender.value)"
        
        // Change responseTime by calling Singleton
        UserDefaultSingleton.sharedUserDefault.reactionTime = sender.value
    }
    
    
    @IBAction func switchValueChanged(sender: UISwitch) {
//        var temp_brightness = UIScreen.mainScreen().brightness
        if sender.on {
            UIScreen.mainScreen().brightness = CGFloat(1.0)
        } else {
            UIScreen.mainScreen().brightness = CGFloat(0.5)
        }
        
    }
    

    override func viewWillAppear(animated: Bool)
    {
        //Load the value from NSUserDefault
        let value = UserDefaultSingleton.sharedUserDefault.reactionTime ?? 1.0// FIXME Initial value
        label.text =  "\(value)"
        slider.value = value
        
        // Check current brightness and reflect to switch
        if UIScreen.mainScreen().brightness == CGFloat(1.0) {
            modeSwitch.setOn(true, animated: false)
        } else {
            modeSwitch.setOn(false, animated: false)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
