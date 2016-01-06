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
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        label.text = "\(sender.value)"
        
        // Change responseTime by calling Singleton
        UserDefaultSingleton.sharedUserDefault.reactionTime = sender.value

    }

    override func viewWillAppear(animated: Bool)
    {
        //Load the value from NSUserDefault
        let value = UserDefaultSingleton.sharedUserDefault.reactionTime ?? 1.0// FIXME Initial value
        label.text =  "\(value)"
        slider.value = value
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
