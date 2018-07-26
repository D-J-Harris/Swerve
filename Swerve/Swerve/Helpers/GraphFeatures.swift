//
//  GraphFeatures.swift
//  Swerve
//
//  Created by Daniel Harris on 26/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import Accelerate
import simd

struct GraphFeatures {
    
    func getRootMeanSquareDiff(device1 results1: [[Double]], device2 results2: [[Double]]) {
        
    }
    
    func normalise(results: [Double]) -> [Double] {
        let mean: Double = results.reduce(0,+) / Double(results.count)
        let deviationTemp: [Double] = results.map{ $0 - mean }.map{ pow($0, 2) }
        let stddv: Double = deviationTemp.reduce(0,+).squareRoot()
        
        return results.map{ ($0 - mean)/stddv }
    }
}
