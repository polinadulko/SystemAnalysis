//
//  ViewController.swift
//  SA2
//
//  Created by Polina Dulko on 3/14/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFile()
        let dataHandler = DataHandler(wineArr: wineArray)
        print("\nДоверительный интервал для математического ожидания:")
        let precisions: [Float] = [0.9, 0.95, 0.975, 0.99]
        for precision in precisions {
            dataHandler.findConfidenceIntervalForExpectationOfX(precision: precision)
        }
        print("")
        for precision in precisions {
            dataHandler.findConfidenceIntervalForExpectationOfY(precision: precision)
        }
        print("\nДоверительный интервал для дисперсии:")
        for precision in precisions {
            dataHandler.findConfidenceIntervalForDispersionOfX(precision: precision)
        }
        print("")
        for precision in precisions {
            dataHandler.findConfidenceIntervalForDispersionOfY(precision: precision)
        }
        print("\nH0: mx = my   H1: mx ≠ my   α = 0.05\n")
        print("a)Для известных дисперсий:", terminator: "")
        dataHandler.hypothesisTestingForKnownDispersions()
        print("б)Для неизвестных дисперсий:", terminator: "")
        dataHandler.hypothesisTestingForUnknownDispersions()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

