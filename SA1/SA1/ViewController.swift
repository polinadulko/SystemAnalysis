//
//  ViewController.swift
//  SA1
//
//  Created by Polina Dulko on 1/31/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Cocoa
import Charts

class ViewController: NSViewController {
    @IBOutlet weak var correlationLabel: NSTextField!
    @IBOutlet weak var chartView: CombinedChartView!
    var wineArray = [Wine]()
    
    func getDataFromFile() {
        guard let fileURL = Bundle.main.url(forResource: "wine", withExtension: "txt") else { return }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            guard let data = FileManager.default.contents(atPath: fileURL.path) else { return }
            guard let dataStr = String(data: data, encoding: .utf8) else { return }
            let strArray = dataStr.components(separatedBy: "\n")
            for str in strArray {
                let values = str.components(separatedBy: ",")
                guard let alcohol = Double(values[1]) else { return }
                guard let colorIntensity = Double(values[10]) else { return }
                let wine = Wine(alcohol: alcohol, colorIntensity: colorIntensity)
                wineArray.append(wine)
            }
        }
    }
    
    func processData() {
        let dataHandler = DataHandler(wineArr: wineArray)
        let correlationCoefficient = dataHandler.calculateCorrelationCoefficient()
        correlationLabel.stringValue = NSString(format: "Correlation coefficient = %1.4f", correlationCoefficient) as String
        let combinedChartData = CombinedChartData()
        combinedChartData.scatterData = dataHandler.createScatterGraph()
        combinedChartData.lineData = dataHandler.createRegression()
        chartView.data = combinedChartData
        chartView.backgroundColor = NSColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFile()
        processData()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

