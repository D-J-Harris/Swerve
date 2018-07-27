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
    @IBOutlet weak var peakCounterLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    //Initialisation
    let motion = CMMotionManager()
    var timer = Timer()
    var backgroundTimer = Timer()
    var timerCounter: Double = 3 //Number of seconds on timer
    let updateFrequency: Double = 1.0 / 100.0 // 1 / hertz
    var csvText: String = "time,attitude Magnitude\n"
    var resultsMatrix = [[Double]]()
    var initialAttitude: CMAttitude? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getTime), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundTimer.invalidate()
    }
    
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        perform(#selector(testMotionViewController.startDeviceMotion), with: nil, afterDelay: 10 -  round(NSDate.timeIntervalSinceReferenceDate).truncatingRemainder(dividingBy: 10))
        
    }
    
    
    
    @objc func startDeviceMotion() {
        
        self.motion.deviceMotionUpdateInterval = self.updateFrequency
        self.motion.startDeviceMotionUpdates()
        sleep(1) //fix this delay at some point
        initialAttitude = self.motion.deviceMotion?.attitude
        self.motion.stopDeviceMotionUpdates()
        
        //timer to fetch motion data
        self.timer = Timer.scheduledTimer(timeInterval: self.updateFrequency, target: self, selector: (#selector(testMotionViewController.updateMotion)), userInfo: nil, repeats: true)
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

                        //store initial attitude here
                        
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
        saveAsCSV(from: self.csvText)
        print("Integral: \(graphFeatures.getIntegral(results: self.resultsMatrix))")
        self.integralLabel.text = String(format: "%.3f", graphFeatures.getIntegral(results: self.resultsMatrix))
        self.peakCounterLabel.text = String(graphFeatures.getNumberOfPeaks(results: self.resultsMatrix))
        //quick methods for allowing in-app reset
        resultsMatrix = [[Double]]()
        timerCounter = 3.0
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
    
    func getInitialAttitude(completion: @escaping ((CMAttitude) -> ())) {
        
        if self.motion.isDeviceMotionAvailable {
            self.motion.startDeviceMotionUpdates()
            if let data = self.motion.deviceMotion {
                completion(data.attitude)
            }
            else{ return }
        }
        else{ return }
        
    }
    
    @objc func getTime() {
        let currTime = round(NSDate.timeIntervalSinceReferenceDate).truncatingRemainder(dividingBy: 10)
        
        
        self.timeLabel.text = String(currTime)
    }

}
