//
//  MotionViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion


class MotionViewController: UIViewController {
    
    //Initialisation
    let motion = CMMotionManager()
    var timer = Timer()
    var backgroundTimer = Timer() //Global sync timer
    var timerCounter: Double = 3 //Number of seconds on timer
    let updateFrequency: Double = 1.0 / 100.0 // hertz
    var resultsMatrix = [[Double]]()
    var initialAttitude: CMAttitude? = nil
    var testLabelText: String = "Receiver So No Data"
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var integralLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = testLabelText
        backgroundTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getTime), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Global sync timer invalidated
        backgroundTimer.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case Constants.Segue.backFromReceiver:
            if User.current.type == Constants.UserDictionary.receiver {
                User.current.type = Constants.UserDictionary.unselected
                UserService.updateUserType(User.current, type: Constants.UserDictionary.unselected)
            }
        case Constants.Segue.toDisplayResult:
            let destination = segue.destination as! DisplayResultViewController
            destination.receivedTextLabelText = User.current.passableTestText 
        default:
            print("error no correct segue identified")
        }
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        //disable button while waiting for syncing
        sender.isEnabled = false
        perform(#selector(MotionViewController.startDeviceMotion), with: nil, afterDelay: 10 -  NSDate.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 10))
        
    }
    
    @objc func startDeviceMotion() {
        
        LoadingOverlay.shared.showSwerveView(self.view)
        self.motion.deviceMotionUpdateInterval = self.updateFrequency
        self.motion.startDeviceMotionUpdates()
        sleep(1)
        initialAttitude = self.motion.deviceMotion?.attitude
        self.motion.stopDeviceMotionUpdates()
        
        //timer to fetch motion data
        self.timer = Timer.scheduledTimer(timeInterval: self.updateFrequency, target: self, selector: (#selector(MotionViewController.updateMotion)), userInfo: nil, repeats: true)
    }
    
    @objc func updateMotion() {
        
        //only want to capture data for timer limit
        if self.timerCounter > 0 {
            
            
            //ensure hardware available
            if self.motion.isDeviceMotionAvailable {
                self.motion.deviceMotionUpdateInterval = self.updateFrequency
                self.motion.showsDeviceMovementDisplay = true
                
                self.motion.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion, error) in
                    
                    //START Code here runs every 'updateFrequency'
                    
                    if let data = self.motion.deviceMotion {
                        
                        //attitude of phone impacted by user
                        data.attitude.multiply(byInverseOf: self.initialAttitude!)

                        //save to matrices to be passed into featureFunctions
                        self.resultsMatrix.append([self.timerCounter,self.magnitudeFromAttitude(attitude: data.attitude)])
                    
                    }
                    self.timerCounter -= self.updateFrequency
                    //END Code here runs every 'updateFrequency'
                }
            }
        }
        else {
            stopDeviceMotion()
        }
    }
    
    func stopDeviceMotion() {
        LoadingOverlay.shared.hideSwerveView()
        let graphFeatures = GraphFeatures()
        self.timer.invalidate()
        self.motion.stopDeviceMotionUpdates()
        self.integralLabel.text = String(format: "%.3f", graphFeatures.getIntegral(results: self.resultsMatrix))
        UserService.updateUserIntegralKey(User.current, integralKey: graphFeatures.getIntegral(results: self.resultsMatrix))
        User.current.integralKey = graphFeatures.getIntegral(results: self.resultsMatrix)
        
        //quick methods for allowing in-app reset
        resultsMatrix = [[Double]]()
        timerCounter = 3.0
        
        //run autochecker and then confirmation alert
        let partnerCheckerService = PartnerCheckerService()
        partnerCheckerService.findMatchingDevice(User.current, self)
        
        startButton.isEnabled = true
    }
    
    // get magnitude of vector via Pythagorean theorem, as String
    func magnitudeFromAttitude(attitude: CMAttitude) -> Double {
        return sqrt(pow(attitude.roll, 2) + pow(attitude.yaw, 2) + pow(attitude.pitch, 2))
    }
    
    //function to retrieve the rounded time modulo 10
    @objc func getTime() {
        let currTime = round(NSDate.timeIntervalSinceReferenceDate).truncatingRemainder(dividingBy: 10)
        self.timeLabel.text = String(currTime)
    }
}
