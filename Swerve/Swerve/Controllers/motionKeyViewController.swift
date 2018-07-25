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
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    
    //Initialisation
    let motion = CMMotionManager()
    var timer = Timer()
    var timerCounter: Double = 3 //Number of seconds on timer
    var isTimerRunning = false
    let updateFrequency: Double = 1.0 / 100.0 // 1 / hertz
    var csvText: String = "time,xValue,yValue,zValue\n"
    
    
    
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
            self.timer = Timer.scheduledTimer(timeInterval: self.updateFrequency * 2, target: self, selector: (#selector(testMotionViewController.updateMotion)), userInfo: nil, repeats: true)
        }
        
        //note this point is reached immediately
    }
    
    
    
    @objc func updateMotion() {
        
        if self.timerCounter >= 0 {  //only want to capture data for 5 seconds
            
            
            //ensure hardware available
            if self.motion.isDeviceMotionAvailable {
                self.motion.deviceMotionUpdateInterval = self.updateFrequency
                self.motion.showsDeviceMovementDisplay = true
                self.motion.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion, error) in
                    
                    //START Code here runs every 'updateFrequency'
                    
                    if let data = self.motion.deviceMotion {
                        
                        //acceleration impacted by user
                        let xFound = data.attitude.pitch; let x = String(format: "%.3f", xFound)
                        let yFound = data.attitude.roll; let y = String(format: "%.3f", yFound)
                        let zFound = data.attitude.yaw; let z = String(format: "%.3f", zFound)
                        let time = String(format: "%.2f", self.timerCounter)
                        
                        
                        //USE MOTION DATA HERE
                        self.xLabel.text = x
                        self.yLabel.text = y
                        self.zLabel.text = z
                        
                        self.csvText.append("\(time),\(x),\(y),\(z)\n") //add data to CSV file
                    }
                    print(self.timerCounter)
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
        self.timer.invalidate()
        self.motion.stopDeviceMotionUpdates()
        isTimerRunning = false
        saveAsCSV(from: self.csvText)
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
}
