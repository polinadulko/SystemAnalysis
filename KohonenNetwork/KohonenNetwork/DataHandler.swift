//
//  DataHandler.swift
//  KohonenNetwork
//
//  Created by Polina Dulko on 4/30/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation

class DataHandler {
    
    func getDataFromFile(title: String) -> [[Double]]? {
        var data = [[Double]]()
        guard let fileURL = Bundle.main.url(forResource: title, withExtension: "txt") else { return nil }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            guard let contents = FileManager.default.contents(atPath: fileURL.path) else { return nil }
            guard let dataStr = String(data: contents, encoding: .utf8) else { return nil }
            let itemsArray = dataStr.components(separatedBy: "\n")
            for item in itemsArray {
                if !item.isEmpty {
                    var parameters = [Double]()
                    let parametersArray = item.components(separatedBy: ",")
                    for parameter in parametersArray {
                        guard let value  = Double(parameter) else { return nil }
                        parameters.append(value)
                    }
                    parameters.removeLast()
                    data.append(parameters)
                }
            }
        }
        return data
    }
    
    func normalizeData(data: [[Double]]) -> [[Double]]? {
        var dataArray = data
        guard let n = dataArray.first?.count else { return nil }
        for i in 0...n - 1 {
            var minValue = Double.infinity
            var maxValue = 0.0
            for item in data {
                if item[i] < minValue {
                    minValue = item[i]
                }
                if item[i] > maxValue {
                    maxValue = item[i]
                }
            }
            for j in 0...dataArray.count - 1 {
                let newValue = (dataArray[j][i] - minValue) / (maxValue - minValue)
                dataArray[j][i] = Double(round(100 * newValue) / 100)
            }
        }
        return dataArray
    }
    
}
