//
//  ViewController.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/1/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

import UIKit
import AVFoundation

class DetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var draw2D: Draw2D!
    @IBOutlet var viewConstraintFromTop: NSLayoutConstraint!
    @IBOutlet var viewConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var eyeNormal: UIImageView!
    @IBOutlet weak var eyeQuestion: UIImageView!
    @IBOutlet weak var eyeExclamationRed: UIImageView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var bottomNotWorking: UIImageView!
    @IBOutlet weak var bottomAwake: UIImageView!
    @IBOutlet weak var bottomDrowsy: UIImageView!
    

    // Session
    var mySession : AVCaptureSession!
    // Camera device
    var myDevice : AVCaptureDevice!
    // Output
    var myOutput : AVCaptureVideoDataOutput!
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    // check now in main view or not
    var active = true
    
    // check item is tapped or untapped (tapped again)
    var tapped = false
    @IBOutlet weak var changeFace: UIButton!
    
    @IBAction func changeFaceTapped(sender: AnyObject) {
        
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        
        if (tapped == false) {
            mixpanel.track("Face hided/showed", properties: ["Face":"Hided"])
            
            tapped = true
            
            self.changeFace.selected = true
            
            self.viewConstraintHeight.active = false
            self.viewConstraintFromTop.active = true
            UIView.animateWithDuration(0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            mixpanel.track("Face hided/showed", properties: ["Face":"Shown"])

            tapped = false

            self.changeFace.selected = false

            self.viewConstraintFromTop.active = false
            self.viewConstraintHeight.active = true
            UIView.animateWithDuration(0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    // Object for face detection
    let detector = Detector()
    // Object for alert
    let wakeupAlert = WakeupAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare camera
        if initCamera() {
            // Start to run
            mySession.startRunning()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            print("Identifier \(identifier)")
        }
    }
    
    // Preparation processing for camera
    func initCamera() -> Bool {
        // make session
        mySession = AVCaptureSession()
        
        // define resolution
//         mySession.sessionPreset = AVCaptureSessionPresetMedium
//        mySession.sessionPreset = AVCaptureSessionPreset640x480
        mySession.sessionPreset = AVCaptureSessionPreset352x288
        
        // get whole devices
        let devices = AVCaptureDevice.devices()
        
        // store back camera to myDevice
        for device in devices {
            if(device.position == AVCaptureDevicePosition.Front){
                //                if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        if myDevice == nil {
            return false
        }
        
        // get VideoInput from back camera
        var myInput: AVCaptureDeviceInput! = nil
        do {
            myInput = try AVCaptureDeviceInput(device: myDevice) as AVCaptureDeviceInput
        } catch let error {
            print(error)
        }
        
        // Add to session
        if mySession.canAddInput(myInput) {
            mySession.addInput(myInput)
        } else {
            return false
        }
        
        // set output direction
        myOutput = AVCaptureVideoDataOutput()
        myOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA) ]
        
        // set FPS
        do {
            try myDevice.lockForConfiguration()
            
            myDevice.activeVideoMinFrameDuration = CMTimeMake(1, 15) // FIXME: You can choose frame ratio (Currently, 1/15 second = 1 frame)
            myDevice.unlockForConfiguration()
        } catch let error {
            print("lock error: \(error)")
            return false
        }
        
        // set delegate
        let queue: dispatch_queue_t = dispatch_queue_create("myqueue",  nil)
        myOutput.setSampleBufferDelegate(self, queue: queue)
        
        // ignore delayed frame
        myOutput.alwaysDiscardsLateVideoFrames = true
        
        // add to session
        if mySession.canAddOutput(myOutput) {
            mySession.addOutput(myOutput)
        } else {
            return false
        }
        
        // set camera's rotation
        for connection in myOutput.connections {
            if let conn = connection as? AVCaptureConnection {
                if conn.supportsVideoOrientation {
                    conn.videoOrientation = AVCaptureVideoOrientation.Portrait
                }
                if conn.supportsVideoMirroring {
                    conn.videoMirrored = true
                }
            }
        }
        
        return true
    }
    
    // Process which is executed in every frames
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!)
    {
        if (active) {
        
            dispatch_sync(dispatch_get_main_queue(), {
                // Transfer to UIImage
                let image = CameraUtil.imageFromSampleBuffer(sampleBuffer)

                // Face recognition
                let facialFeatures = self.detector.recognizeFace(image)
                
    //            // Wakeup alert
                let alertCalled = self.wakeupAlert.checkAlert(facialFeatures.face.isDetected, isEye1Detected:facialFeatures.eye1.isDetected, isEye2Detected:facialFeatures.eye2.isDetected)

                let mixpanel: Mixpanel = Mixpanel.sharedInstance()
                
                // Display real face if tapped is false, display animated eye if tapped is true
                if (self.tapped == false) {
                    self.imageView.image = image
                    
                    let screenSize = UIScreen.mainScreen().bounds // if iphone 5, 320
                    let sessionImageWidth = 288;
                    let sessionImageHeight = 352;
                    let scaleRatioWidth = screenSize.size.width / CGFloat(sessionImageWidth);

                    self.imageView.frame.size.height = CGFloat(sessionImageHeight) * scaleRatioWidth
                    self.draw2D.frame.size.height = self.imageView.frame.size.height

                    if (alertCalled) {

                        mixpanel.track("Alarm triggered")
                        
                        self.bottomAwake.hidden = true
                        self.bottomDrowsy.hidden = false
                        self.bottomNotWorking.hidden = true
                    } else if (facialFeatures.face.isDetected == false){
                        self.bottomAwake.hidden = true
                        self.bottomDrowsy.hidden = true
                        self.bottomNotWorking.hidden = false
                    } else {
                        self.bottomAwake.hidden = false
                        self.bottomDrowsy.hidden = true
                        self.bottomNotWorking.hidden = true
                    }
                    
                    self.draw2D.drawFaceRectangle(facialFeatures)
                    self.draw2D.setNeedsDisplay()
                } else {
                    self.bottomAwake.hidden = true
                    self.bottomDrowsy.hidden = true
                    self.bottomNotWorking.hidden = true
                    
                    // If face is not detected, show question eye
                    if (alertCalled) {
                        
                        mixpanel.track("Alarm triggered")
                        
                        self.eyeNormal.hidden = true
                        self.eyeExclamationRed.hidden = false
                        self.eyeQuestion.hidden = true
                    } else if (facialFeatures.face.isDetected == false){
                        self.eyeNormal.hidden = true
                        self.eyeExclamationRed.hidden = true
                        self.eyeQuestion.hidden = false
                    } else {
                        self.eyeNormal.hidden = false
                        self.eyeExclamationRed.hidden = true
                        self.eyeQuestion.hidden = true
                    }
                }
            })            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        print("prepare for segue")
        active = false
        
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        
        if (segue.identifier == "Instruction") {
            mixpanel.track("Main view segued", properties: ["Navigation":"Instruction"])
        } else if (segue.identifier == "Setting") {
            mixpanel.track("Main view segued", properties: ["Navigation":"Setting"])
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        active = true
        
        // Show instruction for first launch
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("firstLaunchForInstruction") {
            defaults.setBool(false, forKey: "firstLaunchForInstruction")
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
//            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("Instruction")
//            navigationController.viewControllers = [initialViewController]
//            self.window?.rootViewController = navigationController
//            self.window?.makeKeyAndVisible(

//            let navigationController = self.storyboard!.instantiateInitialViewController() as! UINavigationController
//            let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Instruction")
//            navigationController.viewControllers = [targetViewController]
//            self.presentViewController( navigationController, animated: true, completion: nil)
            self.performSegueWithIdentifier("Instruction", sender:self)
        
        }
    }
}