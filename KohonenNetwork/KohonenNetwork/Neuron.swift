//
//  Neuron.swift
//  KohonenNetwork
//
//  Created by Polina Dulko on 4/30/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation

class Neuron {
    
    var n = 0
    var weights = [Double]()
    
    init(numOfParameters: Int) {
        n = numOfParameters
        for _ in 0...n - 1 {
            var randWeight: CGFloat = 1
            let coefficient = 1 / sqrt(Double(n))
            while (Double(randWeight) < 0.5 - coefficient) || (Double(randWeight) > 0.5 + coefficient) {
                randWeight = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
            }
            let weight = Double(round(100 * randWeight) / 100)
            weights.append(weight)
        }
    }
    
}
