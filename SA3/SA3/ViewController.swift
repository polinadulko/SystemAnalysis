//
//  ViewController.swift
//  SA3
//
//  Created by Polina Dulko on 3/23/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Cocoa
import Charts

class ViewController: NSViewController {

    @IBOutlet weak var firstChartView: BarChartView!
    @IBOutlet weak var secondChartView: BarChartView!
    @IBOutlet weak var firstImageView: NSImageView!
    @IBOutlet weak var secondImageView: NSImageView!
    @IBOutlet weak var firstImageLabel: NSTextField!
    @IBOutlet weak var secondImageLabel: NSTextField!
    @IBOutlet weak var commonResultsLabel: NSTextField!
    let imageProcessor = ImageProcessor()
    var xIntensities = [Int]()
    var yIntensities = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let firstSourceImage = NSImage(named: "image4") else { return }
        let firstImageConverter = ImageConverter(sourceImage: firstSourceImage)
        if let resultImage = firstImageConverter.convertToGrayscale() {
            firstImageView.image = NSImage(cgImage: resultImage, size: NSZeroSize)
            xIntensities = imageProcessor.getIntensitiesArray(sourceImage: resultImage)
            let histogramData = imageProcessor.buildHistogram(dataArray: xIntensities, title: "Гистограмма 1")
            firstChartView.data = histogramData
            firstChartView.barData?.barWidth = 10
            firstChartView.data?.setDrawValues(false)
            firstImageLabel.stringValue = imageProcessor.calculateParameters()
        }
        guard let secondSourceImage = NSImage(named: "image1") else { return }
        let secondImageConverter = ImageConverter(sourceImage: secondSourceImage)
        if let resultImage = secondImageConverter.convertToGrayscale() {
            secondImageView.image = NSImage(cgImage: resultImage, size: NSZeroSize)
            yIntensities = imageProcessor.getIntensitiesArray(sourceImage: resultImage)
            let histogramData = imageProcessor.buildHistogram(dataArray: yIntensities, title: "Гистограмма 2")
            secondChartView.data = histogramData
            secondChartView.barData?.barWidth = 10
            secondChartView.data?.setDrawValues(false)
            secondImageLabel.stringValue = imageProcessor.calculateParameters()
            //Коэффициент корреляции
            let correlationForImages = imageProcessor.calculateCorrelationCoefficient(xArray: xIntensities, yArray: yIntensities)
            let (correlationForHistograms, xHistogramDictionary, yHistogramDictionary) = getCorrelationForHistograms(imageProcessor: imageProcessor)
            commonResultsLabel.stringValue = NSString(format: "Коэффициент корреляции: для гистограмм = %.4f,  для изображений = %.4f\n", correlationForHistograms, correlationForImages) as String
            //Проверка гипотез
            let criticalValue = 33.92
            commonResultsLabel.stringValue += "Проверка гипотез:\nH0 – распределение соответствует нормальному, H1 ­- распределение не соответствует нормальному\nα = 0.05    " + (NSString(format: "x2(кр) = %.2f\n", criticalValue) as String) + "1. " + imageProcessor.hypothesisTesting(histogramData: xHistogramDictionary) + "\n2. " + imageProcessor.hypothesisTesting(histogramData: yHistogramDictionary)
        }
    }
    
    func getCorrelationForHistograms(imageProcessor: ImageProcessor) -> (Double, [Int: Int], [Int: Int]) {
        let xHistogramDictionary = imageProcessor.getDataForHistogram(dataArray: xIntensities)
        var xHistogramArray = [Int]()
        for item in xHistogramDictionary {
            xHistogramArray.append(item.value)
        }
        let yHistogramDictionary = imageProcessor.getDataForHistogram(dataArray: yIntensities)
        var yHistogramArray = [Int]()
        for item in yHistogramDictionary {
            yHistogramArray.append(item.value)
        }
        let correlationForHistograms = imageProcessor.calculateCorrelationCoefficient(xArray: xHistogramArray, yArray: yHistogramArray)
        return (correlationForHistograms, xHistogramDictionary, yHistogramDictionary)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

