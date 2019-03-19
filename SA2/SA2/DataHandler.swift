//
//  DataHandler.swift
//  SA2
//
//  Created by Polina Dulko on 3/14/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation

class DataHandler {
    
    var wineArray = [Wine]()
    var alcoholArray = [Double]()
    var colorIntensityArray = [Double]()
    let laplaceArguments: [Float: Double] = [0.45: 1.65, 0.475: 1.96, 0.4875: 2.24, 0.495: 2.58]
    
    init(wineArr: [Wine]) {
        self.wineArray = wineArr
        for wine in wineArray {
            alcoholArray.append(wine.alcohol)
            colorIntensityArray.append(wine.colorIntensity)
        }
    }
    
    func calculateStandartDeviation(array: [Double]) -> Double {
        let n = Double(array.count)
        let average = array.reduce(0, +) / n
        var standartDeviation: Double = 0
        for value in array {
            standartDeviation += pow(value - average, 2)
        }
        return standartDeviation/(n-1)
    }
    
    func findConfidenceIntervalForExpectationOfX(precision: Float) {
        guard let arg = laplaceArguments[precision/2] else { return }
        let n = Double(alcoholArray.count)
        let sum = alcoholArray.reduce(0, +)
        let average = sum/n
        let standartDeviation = calculateStandartDeviation(array: alcoholArray)
        let min = average - standartDeviation * arg / sqrt(n)
        let max = average + standartDeviation * arg / sqrt(n)
        let resultStr = NSString(format: "γ = %1.3f   %1.3f < mx < %1.3f", precision, min, max) as String
        print(resultStr)
    }
    
    func findConfidenceIntervalForExpectationOfY(precision: Float) {
        guard let arg = laplaceArguments[precision/2] else { return }
        let n = Double(colorIntensityArray.count)
        let sum = colorIntensityArray.reduce(0, +)
        let average = sum/n
        let standartDeviation = calculateStandartDeviation(array: colorIntensityArray)
        let min = average - standartDeviation * arg / sqrt(n)
        let max = average + standartDeviation * arg / sqrt(n)
        let resultStr = NSString(format: "γ = %1.3f   %1.3f < my < %1.3f", precision, min, max) as String
        print(resultStr)
    }
    
    func findConfidenceIntervalForDispersionOfX(precision: Float) {
        guard let arg = laplaceArguments[precision/2] else { return }
        let n = Double(wineArray.count)
        let standartDeviation = calculateStandartDeviation(array: alcoholArray)
        let min = pow(standartDeviation, 2) - arg * sqrt(2/(n-1)) * pow(standartDeviation, 2)
        let max = pow(standartDeviation, 2) + arg * sqrt(2/(n-1)) * pow(standartDeviation, 2)
        let resultStr = NSString(format: "γ = %1.3f   %1.3f < Dx < %1.3f", precision, min, max) as String
        print(resultStr)
    }
    
    func findConfidenceIntervalForDispersionOfY(precision: Float) {
        guard let arg = laplaceArguments[precision/2] else { return }
        let n = Double(wineArray.count)
        let standartDeviation = calculateStandartDeviation(array: colorIntensityArray)
        let min = pow(standartDeviation, 2) - arg * sqrt(2/(n-1)) * pow(standartDeviation, 2)
        let max = pow(standartDeviation, 2) + arg * sqrt(2/(n-1)) * pow(standartDeviation, 2)
        let resultStr = NSString(format: "γ = %1.3f   %1.3f < Dy < %1.3f", precision, min, max) as String
        print(resultStr)
    }
    
    func hypothesisTestingForKnownDispersions() {
        //For 5% level of significance
        let criticalValue = 1.96
        let n = Double(colorIntensityArray.count)
        let averageOfX = alcoholArray.reduce(0, +) / n
        let averageOfY = colorIntensityArray.reduce(0, +) / n
        let standartDeviationOfX = calculateStandartDeviation(array: alcoholArray)
        let z = (averageOfX - averageOfY) / (standartDeviationOfX / sqrt(n))
        if z > -criticalValue && z < criticalValue {
            print(" H0")
        } else {
            print(" H1")
        }
        let criteriaStr = NSString(format: "Критическое значение z = %1.2f\nz = %1.2f\n", criticalValue, z)
        print(criteriaStr)
    }
    
    func hypothesisTestingForUnknownDispersions() {
        //For 5% level of significance
        let criticalValue = 1.97
        let n = Double(colorIntensityArray.count)
        let averageOfX = alcoholArray.reduce(0, +) / n
        let averageOfY = colorIntensityArray.reduce(0, +) / n
        let standartDeviationOfX = calculateStandartDeviation(array: alcoholArray)
        let standartDeviationOfY = calculateStandartDeviation(array: colorIntensityArray)
        let t = (averageOfX - averageOfY) / sqrt(pow(standartDeviationOfX, 2)/n + pow(standartDeviationOfY, 2) / n)
        if t > -criticalValue && t < criticalValue {
            print(" H0")
        } else {
            print(" H1")
        }
        let criteriaStr = NSString(format: "Критическое значение t = %1.2f\nt = %1.2f\n", criticalValue, t)
        print(criteriaStr)
    }
    
}
