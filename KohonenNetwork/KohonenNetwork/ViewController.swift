//
//  ViewController.swift
//  KohonenNetwork
//
//  Created by Polina Dulko on 4/30/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let k = 3
    var neurons = [Neuron]()
    var data = [[Double]]()
    var normalizedData = [[Double]]()
    var numOfParameters = 0
    let learningNum = 5
    let learningSize = 40

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataHandler = DataHandler()
        guard let dataArray = dataHandler.getDataFromFile(title: "seeds_dataset"), let n = dataArray.first?.count else { return }
        numOfParameters = n
        data = dataArray.shuffled()
        guard let normalizedArray = dataHandler.normalizeData(data: data) else { return }
        normalizedData = normalizedArray
        
        //Set initial weights
        print("Начальные весовые коэффициенты:")
        for _ in 0...k - 1 {
            let neuron = Neuron(numOfParameters: numOfParameters)
            print(neuron.weights)
            neurons.append(neuron)
        }
        
        for i in 0...learningNum - 1 {
            for j in 0...learningSize - 1 {
                let index = learningSize * i + j
                let clusterNum = findNearestNeuron(for: normalizedData[index], speedCoefficient: 0.4 - Double(i) * 0.05)
                data[index].append(Double(clusterNum))
            }
        }
        
    }
    
    func findNearestNeuron(for vector: [Double], speedCoefficient: Double) -> Int {
        var clusterIndex = 1
        var minDistance = Double.infinity
        for i in 0...k - 1 {
            var distance = 0.0
            for j in 0...numOfParameters - 1 {
                distance += pow(vector[j] - neurons[i].weights[j], 2)
            }
            distance = sqrt(distance)
            if distance < minDistance {
                clusterIndex = i
                minDistance = distance
            }
        }
        //Correct weights for the nearest neuron
        for i in 0...numOfParameters - 1 {
            let weight = neurons[clusterIndex].weights[i] + speedCoefficient * (vector[i] - neurons[clusterIndex].weights[i])
            neurons[clusterIndex].weights[i] = Double(round(100 * weight) / 100)
        }
        return clusterIndex + 1
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

