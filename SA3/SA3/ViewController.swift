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
    var firstImage: CGImage?
    var secondImage: CGImage?
    let imageProcessor = ImageProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let firstSourceImage = NSImage(named: "image1") else { return }
        let firstImageConverter = ImageConverter(sourceImage: firstSourceImage)
        if let resultImage = firstImageConverter.convertToGrayscale() {
            firstImage = resultImage
            firstImageView.image = NSImage(cgImage: resultImage, size: NSZeroSize)
            let intensities = imageProcessor.getIntensitiesArray(sourceImage: resultImage)
            let histogramData = imageProcessor.buildHistogram(dataArray: intensities, title: "Гистограмма 1")
            firstChartView.data = histogramData
            firstChartView.barData?.barWidth = 10
            firstChartView.data?.setDrawValues(false)
            let resultStr = imageProcessor.calculateParameters()
            print(resultStr)
        }
        guard let secondSourceImage = NSImage(named: "image2") else { return }
        let secondImageConverter = ImageConverter(sourceImage: secondSourceImage)
        if let resultImage = secondImageConverter.convertToGrayscale() {
            secondImage = resultImage
            secondImageView.image = NSImage(cgImage: resultImage, size: NSZeroSize)
            let intensities = imageProcessor.getIntensitiesArray(sourceImage: resultImage)
            let histogramData = imageProcessor.buildHistogram(dataArray: intensities, title: "Гистограмма 2")
            secondChartView.data = histogramData
            secondChartView.barData?.barWidth = 10
            secondChartView.data?.setDrawValues(false)
            let resultStr = imageProcessor.calculateParameters()
            print(resultStr)
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

