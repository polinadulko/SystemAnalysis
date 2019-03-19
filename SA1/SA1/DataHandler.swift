//
//  DataHandler.swift
//  SA1
//
//  Created by Polina Dulko on 2/3/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation
import Charts

class DataHandler {
    var wineArray = [Wine]()
    
    init(wineArr: [Wine]) {
        self.wineArray = wineArr
        wineArray.sort { (wine1, wine2) -> Bool in
            return wine1.alcohol < wine2.alcohol
        }
    }
    
    func calculateCorrelationCoefficient() -> Double {
        var sumOfX: Double = 0
        var sumOfY: Double = 0
        for wine in wineArray {
            sumOfX += wine.alcohol
            sumOfY += wine.colorIntensity
        }
        let averageX = sumOfX/Double(wineArray.count)
        let averageY = sumOfY/Double(wineArray.count)
        var a: Double = 0
        for wine in wineArray {
            a += (wine.alcohol-averageX)*(wine.colorIntensity-averageY)
        }
        var x: Double = 0
        var y: Double = 0
        for wine in wineArray {
            x += pow(wine.alcohol-averageX, 2)
            y += pow(wine.colorIntensity-averageY, 2)
        }
        return a/sqrt(x*y)
    }
    
    func createScatterGraph() -> ScatterChartData {
        var chartDataEntryArray = [ChartDataEntry]()
        for wine in wineArray {
            let entry = ChartDataEntry(x: wine.alcohol, y: wine.colorIntensity)
            chartDataEntryArray.append(entry)
        }
        let scatterChartDataSet = ScatterChartDataSet(values: chartDataEntryArray)
        scatterChartDataSet.colors = [NSUIColor.purple]
        scatterChartDataSet.shapeRenderer = CircleShapeRenderer()
        scatterChartDataSet.drawValuesEnabled = false
        return ScatterChartData(dataSet: scatterChartDataSet)
    }
    
    func createRegression() -> LineChartData {
        var sumOfXY: Double = 0
        var sumOfX: Double = 0
        var sumOfY: Double = 0
        var sumOfX2: Double = 0
        for wine in wineArray {
            let x = wine.alcohol
            let y = wine.colorIntensity
            sumOfXY += x*y
            sumOfX += x
            sumOfY += y
            sumOfX2 += pow(x, 2)
        }
        let n = Double(wineArray.count)
        let a: Double = (n * sumOfXY - sumOfX * sumOfY) / (n * sumOfX2 - pow(sumOfX, 2))
        let b: Double = (sumOfY * sumOfX2 - sumOfX * sumOfXY) / (n * sumOfX2 - pow(sumOfX, 2))
        var chartDataEntryArray = [ChartDataEntry]()
        if let firstItem = wineArray.first, let lastItem = wineArray.last {
            let minX = Int(firstItem.alcohol) - 1
            let maxX = Int(lastItem.alcohol) + 1
            for x in minX...maxX {
                let y: Double = a * Double(x) + b
                let entry = ChartDataEntry(x: Double(x), y: y)
                chartDataEntryArray.append(entry)
            }
        }
        let line = LineChartDataSet(values: chartDataEntryArray, label: "Regression")
        line.colors = [NSUIColor.red]
        line.circleRadius = 0
        line.drawValuesEnabled = false
        return LineChartData(dataSet: line)
    }
}
