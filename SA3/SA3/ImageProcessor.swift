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
    
    func getIntensitiesArray(sourceImage: CGImage) -> [UInt8] {
        let width = sourceImage.width
        let height = sourceImage.height
        let bitsPerComponent = sourceImage.bitsPerComponent
        let bytesPerRow = sourceImage.bytesPerRow
        let totalBytes = height * bytesPerRow
        var intensities = [UInt8](repeating: 0, count: totalBytes)
        if let context = CGContext(data: &intensities, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: 0) {
            context.draw(sourceImage, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
        }
        return intensities
    }
    
    func getDataForHistogram(dataArray: [UInt8]) -> [Int: Int] {
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
        return intensitiesDistribution
    }
    
    func buildHistogram(dataArray: [UInt8], title: String) -> BarChartData {
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
    
}
