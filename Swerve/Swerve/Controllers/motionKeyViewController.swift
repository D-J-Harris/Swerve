//
//  motionKeyViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 25/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class testMotionViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var integralLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    
    //Initialisation
    let motion = CMMotionManager()
    var timer = Timer()
    var timerCounter: Double = 3 //Number of seconds on timer
    var isTimerRunning = false
    let updateFrequency: Double = 1.0 / 100.0 // 1 / hertz
    var csvText: String = "time,attitude Magnitude\n"
    var initialAttitude: CMAttitude? = nil //for reference from start position
    var isFirst = true //to interact with just first loop of device updates and store initial attitude
    var resultsMatrix = [[Double]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        isTimerRunning = true
        startDeviceMotion()
    }
    
    
    
    func startDeviceMotion() {
        
        if isTimerRunning == true {
            
            //timer to fetch motion data
            self.timer = Timer.scheduledTimer(timeInterval: self.updateFrequency, target: self, selector: (#selector(testMotionViewController.updateMotion)), userInfo: nil, repeats: true)
        }
        
        //note this point is reached immediately
    }
    
    
    
    @objc func updateMotion() {
        
        if self.timerCounter > 0 {  //only want to capture data for timer limit
            
            
            //ensure hardware available
            if self.motion.isDeviceMotionAvailable {
                self.motion.deviceMotionUpdateInterval = self.updateFrequency
                self.motion.showsDeviceMovementDisplay = true
                
                self.motion.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion, error) in
                    
                    //START Code here runs every 'updateFrequency'
                    
                    if let data = self.motion.deviceMotion {
                        
                        //Store initial attitude for reference
                        if self.isFirst == true {
                            self.initialAttitude = data.attitude
                            self.isFirst = false
                        }
                        
                        //attitude of phone impacted by user
                        data.attitude.multiply(byInverseOf: self.initialAttitude!)
                        let attitudeMagnitude = String(format: "%.3f", self.magnitudeFromAttitude(attitude: data.attitude))
                        let time = String(format: "%.2f", self.timerCounter)
                        
                        
                        //save to matrices to be passed into featureFunctions
                        self.resultsMatrix.append([self.timerCounter,self.magnitudeFromAttitude(attitude: data.attitude)])
                        
                        
                        
                        
                        self.csvText.append("\(time),\(attitudeMagnitude)\n") //add data to CSV file
                    }
                    print(self.timerCounter
                    )
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
        let graphFeatures = GraphFeatures()
        self.timer.invalidate()
        self.motion.stopDeviceMotionUpdates()
        isTimerRunning = false
        saveAsCSV(from: self.csvText)
        print("Integral: \(graphFeatures.getIntegral(results: self.resultsMatrix))")
        self.integralLabel.text = String(format: "%.3f", graphFeatures.getIntegral(results: self.resultsMatrix))
    }
    
    
    func saveAsCSV(from csvFile: String) {
        let filemanager = FileManager.default
        do {
            let path = try filemanager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("accData.csv")
            try csvFile.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("error creating file")
        }
    }
    
    // get magnitude of vector via Pythagorean theorem, as String
    func magnitudeFromAttitude(attitude: CMAttitude) -> Double {
        return sqrt(pow(attitude.roll, 2) + pow(attitude.yaw, 2) + pow(attitude.pitch, 2))
    }
}
