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

class GraphFeatures {
    
    //trapezium rule using time interval as trapz heights
    func getIntegral(results: [[Double]]) -> Double {
        
        let interval: Double = abs(results[0][0] - results[1][0])

        var runningHelpSum: Double = 0
        runningHelpSum += results[0][1] + results[results.count-1][1]
        for i in 1...results.count-2 {
            runningHelpSum += 2 * results[i][1]
        }
        
        return 0.5 * interval * runningHelpSum
    }
    
    
    func getSimilarityCoefficient(results1: [[Double]], results2: [[Double]]) -> Double {
        
        
        
        
        return 0.0
    }
    
    
    
    func normalise(results: [Double]) -> [Double] {
        let mean: Double = results.reduce(0,+) / Double(results.count)
        let deviationTemp: [Double] = results.map{ $0 - mean }.map{ pow($0, 2) }
        let stddv: Double = deviationTemp.reduce(0,+).squareRoot()
        
        return results.map{ ($0 - mean)/stddv }
    }
}
