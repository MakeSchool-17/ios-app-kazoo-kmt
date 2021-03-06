//
//  SettingTableViewController.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 1/11/16.
//  Copyright © 2016 mycompany. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    // Get title and ID of alarm from WakeupAlert.swift
    @IBOutlet weak var alarmCell1: UILabel!
    @IBOutlet weak var alarmCell2: UILabel!
    @IBOutlet weak var alarmCell3: UILabel!
    let alarmTitleForSetting = alarmTitle
    let alarmIDForSetting = alarmID
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    // Reaction time
    @IBAction func sliderValueChanged(sender: UISlider) {
        // Round the value
        label.text = String(format: "%.1f", sender.value)
        
        // Change responseTime by calling Singleton
        UserDefaultSingleton.sharedUserDefault.reactionTime = sender.value
    }
    
    // Night mode
    @IBAction func switchValueChanged(sender: UISwitch) {
        if sender.on {
            UIScreen.mainScreen().brightness = CGFloat(1.0)
        } else {
            UIScreen.mainScreen().brightness = CGFloat(0.5) //FIXME Should change to keep the value of brightness which was before night mode is set on
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        //Load the value from NSUserDefault
        let value = UserDefaultSingleton.sharedUserDefault.reactionTime ?? 1.0// FIXME Initial value
        // Round the value
//        label.text =  "\(value)"
        label.text = String(format: "%.1f", value)
        slider.value = value
        
        // Check current brightness and reflect to switch
        if UIScreen.mainScreen().brightness == CGFloat(1.0) {
            modeSwitch.setOn(true, animated: false)
        } else {
            modeSwitch.setOn(false, animated: false)
        }
        
        // Display the alarm name
        alarmCell1.text = "\(alarmTitle[0])"
        alarmCell2.text = "\(alarmTitle[1])"
        alarmCell3.text = "\(alarmTitle[2])"

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

/*
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
//        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = alarmTitleForSetting[indexPath.row] as? String

        return cell
    }
*/
    
    // When cell is tapped
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if indexPath.section == 1 { //Alarm section is 2nd part (check storyboard)
            let selectedAlarm = alarmIDForSetting[indexPath.row] as? Int
            if selectedAlarm != nil {
                UserDefaultSingleton.sharedUserDefault.currentAlarmID = selectedAlarm
            }
        }
    }
    
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
