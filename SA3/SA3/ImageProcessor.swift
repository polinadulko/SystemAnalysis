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
            if intensity >= intervalStart && intensity <= intervalStart + 10 && intervalStart < 255 {
                count = count + 1
            } else if intervalStart < 255 {
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
   
    func calculateStandartDeviation(array: [Int]) -> Int {
        let n = array.count
        let average = array.reduce(0, +) / n
        var standartDeviation: Double = 0
        for value in array {
            standartDeviation += pow(Double(value - average), 2)
        }
        return Int(standartDeviation) / (n-1)
    }
    
    func calculateParameters() -> String {
        guard intensitiesArray.count != 0 else { return "" }
        let n = intensitiesArray.count
        let average = intensitiesArray.reduce(0, +) / n
        let standartDeviation = calculateStandartDeviation(array: intensitiesArray)
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
        return "m = \(average)\nD = \(standartDeviation)\nМедиана = \(median)\nМода = \(maxCount.key)"
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
    
}
