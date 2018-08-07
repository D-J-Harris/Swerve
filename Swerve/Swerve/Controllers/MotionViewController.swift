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
    let colorAnimation = CABasicAnimation(keyPath: "borderColor")
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerView.layer.masksToBounds = true
        timerView.layer.cornerRadius = timerView.frame.width / 2
        timerView.layer.borderWidth = 4
        usernameLabel.text = User.current.username
        
        //button shadow and effect
        startButton.layer.masksToBounds = false
        startButton.layer.shadowOpacity = 0.8
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowRadius = 5
        startButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        //add color animation to timer border
        self.colorAnimation.fromValue = UIColor(displayP3Red: 0.431, green: 0.918, blue: 0.667, alpha: 1).cgColor
        self.colorAnimation.toValue = UIColor(displayP3Red: 0.961, green: 0.408, blue: 0.349, alpha: 1).cgColor
        self.colorAnimation.duration = 10
        self.colorAnimation.repeatCount = .infinity
        
        backgroundTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getTime), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.colorAnimation.timeOffset = round(NSDate.timeIntervalSinceReferenceDate).truncatingRemainder(dividingBy: 10)
        timerView.layer.add(colorAnimation, forKey: "borderColor")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            destination.receivedID = User.current.passableTestText 
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
        let currTime = 10 - round(NSDate.timeIntervalSinceReferenceDate).truncatingRemainder(dividingBy: 10)
        self.timeLabel.text = String(currTime)
    }
}
