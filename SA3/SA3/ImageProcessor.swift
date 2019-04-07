//
//  ImageProcessor.swift
//  SA3
//
//  Created by Polina Dulko on 3/23/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation
import Charts

class ImageProcessor {
    
    var intensitiesArray = [Int]()
    
    func getIntensitiesArray(sourceImage: CGImage) -> [Int] {
        let width = sourceImage.width
        let height = sourceImage.height
        let bitsPerComponent = sourceImage.bitsPerComponent
        let bytesPerRow = sourceImage.bytesPerRow
        let totalBytes = height * bytesPerRow
        var intensities = [UInt8](repeating: 0, count: totalBytes)
        if let context = CGContext(data: &intensities, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: 0) {
            context.draw(sourceImage, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
        }
        var newArray = [Int]()
        for intensity in intensities {
            newArray.append(Int(intensity))
        }
        intensitiesArray = newArray
        return newArray
    }
    
    func getDataForHistogram(dataArray: [Int]) -> [Int: Int] {
        var sortedArray = dataArray
        sortedArray.sort { (first, second) -> Bool in
            return first < second
        }
        var intensitiesDistribution: [Int: Int] = [:]
        var intervalStart = 0
        var count = 0
        for intensity in sortedArray {
            if intensity >= intervalStart && intensity <= intervalStart + 10 && intervalStart < 260 {
                count = count + 1
            } else if intervalStart < 260 {
                intensitiesDistribution[intervalStart] = count
                intervalStart = intervalStart + 10
                count = 0
            }
        }
        for intervalStart in 0...25 {
            if intensitiesDistribution[intervalStart * 10] == nil {
                intensitiesDistribution[intervalStart * 10] = 0
            }
        }
        return intensitiesDistribution
    }
    
    func buildHistogram(dataArray: [Int], title: String) -> BarChartData {
        let intensitiesDistribution = getDataForHistogram(dataArray: dataArray)
        var dataEntries: [BarChartDataEntry] = []
        for intervalStart in 0...25 {
            var count = 0
            if intensitiesDistribution[intervalStart * 10] != nil {
                count = intensitiesDistribution[intervalStart * 10]!
            }
            let dataEntry = BarChartDataEntry(x: Double(intervalStart * 10), y: Double(count))
            dataEntries.append(dataEntry)
        }
        let dataSet = BarChartDataSet(values: dataEntries, label: title)
        dataSet.colors = [NSUIColor(calibratedRed: 20/255, green: 142/255, blue: 97/255, alpha: 1.0)]
        return BarChartData(dataSet: dataSet)
    }
   
    func calculateDispersion(array: [Int]) -> Int {
        let n = array.count
        let average = array.reduce(0, +) / n
        var dispersion: Double = 0
        for value in array {
            dispersion += pow(Double(value), 2) - pow(Double(average), 2)
        }
        return Int(dispersion) / (n-1)
    }
    
    func calculateParameters() -> String {
        guard intensitiesArray.count != 0 else { return "" }
        let n = intensitiesArray.count
        let average = intensitiesArray.reduce(0, +) / n
        let dispersion = calculateDispersion(array: intensitiesArray)
        intensitiesArray.sort { (first, second) -> Bool in
            first < second
        }
        var median  = 0
        let middleNum = intensitiesArray.count / 2
        if intensitiesArray.count % 2 == 0 {
            median = (intensitiesArray[middleNum] + intensitiesArray[middleNum + 1]) / 2
        } else {
            median = intensitiesArray[middleNum]
        }
        var counts = [Int: Int]()
        intensitiesArray.forEach { (intensity) in
            if let count = counts[intensity] {
                counts[intensity] = count + 1
            } else {
                counts[intensity] = 1
            }
        }
        guard let maxCount = counts.max(by: { (first, second) -> Bool in
            first.value < second.value
        }) else { return "" }
        let standartDeviation = Int(sqrt(Double(dispersion)))
        return "m = \(average), D = \(standartDeviation)\nМедиана = \(median)\nМода = \(maxCount.key)"
    }
    
    func calculateCorrelationCoefficient(xArray: [Int], yArray: [Int]) -> Double {
        let n = xArray.count
        let averageX = xArray.reduce(0, +) / n
        let averageY = yArray.reduce(0, +) / n
        var a = 0
        for i in 0...xArray.count-1 {
            a += (xArray[i] - averageX) * (yArray[i] - averageY)
        }
        var tempX: Double = 0
        var tempY: Double = 0
        for i in 0...xArray.count-1 {
            tempX += pow(Double(xArray[i] - averageX), 2)
            tempY += pow(Double(yArray[i] - averageY), 2)
        }
        return Double(a) / sqrt(tempX * tempY)
    }
    
    func hypothesisTesting(histogramData: [Int: Int]) -> String {
        let totalCount = histogramData.reduce(0) { (result: Int, item: (Int, Int)) -> Int in
            return result + item.1
        }
        var average = 0
        for intervalStart in 0...25 {
            var intervalValue = intervalStart * 10 + 5
            if intervalStart == 25 {
                intervalValue = intervalStart * 10 + 3
            }
            guard let intervalCount = histogramData[intervalStart * 10] else { return "" }
            average += intervalValue * intervalCount / totalCount
        }
        var dispersion: Double = 0
        for intervalStart in 0...25 {
            var intervalValue = intervalStart * 10 + 5
            if intervalStart == 25 {
                intervalValue = intervalStart * 10 + 3
            }
            guard let intervalCount = histogramData[intervalStart * 10] else { return "" }
            dispersion += pow(Double(intervalValue - average), 2) * Double(intervalCount)
        }
        dispersion /= Double(totalCount)
        let standartDeviation = sqrt(dispersion)
     
        var theoreticalValues = [Int]()
        for intervalStart in 0...25 {
            let u = Double(intervalStart * 10 - average) / standartDeviation
            let y = Double(totalCount * 10) / standartDeviation * exp(-pow(u, 2) / 2) / sqrt(2 * Double.pi)
            theoreticalValues.append(Int(y))
        }
        
        var resValue: Double = 0
        for intervalStart in 0...25 {
            let theoreticalValue = theoreticalValues[intervalStart]
            guard let intervalCount = histogramData[intervalStart * 10] else { return "" }
            resValue += pow(Double(intervalCount - theoreticalValue), 2) / Double(theoreticalValue)
        }
        
        //For 0.05 level of significance
        let criticalValue = 33.92
        var resStr = NSString(format: "x2(набл) = %.2f  ->  ", resValue) as String
        if resValue > criticalValue {
            resStr += "H1"
        } else {
            resStr += "H0"
        }
        return resStr
    }
    
}
