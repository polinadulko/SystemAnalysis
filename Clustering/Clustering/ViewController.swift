//
//  ViewController.swift
//  Clustering
//
//  Created by Polina Dulko on 4/7/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var chartView: NChartView!
    let textHandler = TextHandler()
    let setsTitles = ["Networking", "Medicine", "Sociology"]
    var thesaurusArray = [[String]]()
    var vectorsForSetsArray = [[[Int]]]()
    var clusterCenters: [[Int]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.chart.licenseKey = chartsLicenseKey
        chartView.chart.drawIn3D = true
        
        for i in 0...2 {
            guard let setOfTexts = textHandler.getSetOfTexts(for: setsTitles[i]) else { return }
            thesaurusArray.append(textHandler.createThesaurus(for: setOfTexts))
            printThesaurus(n: i + 1, thesaurus: thesaurusArray[i])
        }
        
        let clasteringHandler = ClasteringHandler(firstThesaurus: thesaurusArray[0], secondThesaurus: thesaurusArray[1], thirdThesaurus: thesaurusArray[2])
        for i in 0...2 {
            let vectorsForSet = textHandler.getVectorsForSet(set: setsTitles[i], clasteringHandler: clasteringHandler)
            print("\nВектора признаков \(i + 1):")
            for vector in vectorsForSet {
                print(vector)
            }
            vectorsForSetsArray.append(vectorsForSet)
        }
        
        let kMeans = KMeans()
        clusterCenters = kMeans.getClasterCenters(vectors: vectorsForSetsArray)
        for i in 1...3 {
            addSeriesToChart(num: i)
            addSeriesToChart(num: 10 + i)
        }
        self.chartView.chart.updateData()
        
        print(kMeans.defineClaster(for: vectorsForSetsArray[2][2]))
    }
    
    func createMarker(color: NSColor, size: Float) -> NChartMarker {
        let marker = NChartMarker()
        marker.brush = NChartSolidColorBrush(color: color)
        marker.shape = NChartMarkerShape.circle
        marker.size = size
        return marker
    }
    
    func addSeriesToChart(num: Int) {
        let series = NChartBubbleSeries()
        var markerColor = NSColor.black
        var markerSize: Float = 8
        if num % 10 == 1 {
            markerColor = NSColor(displayP3Red: 140/255, green: 25/255, blue: 88/255, alpha: 1.0)
        } else if num % 10 == 2 {
            markerColor = NSColor(displayP3Red: 25/255, green: 146/255, blue: 46/255, alpha: 1.0)
        } else if num % 10 == 3 {
            markerColor = NSColor(displayP3Red: 194/255, green: 0/255, blue: 13/255, alpha: 1.0)
        }
        if num > 10 {
            markerSize = 14
        }
        series.marker = createMarker(color: markerColor, size: markerSize)
        series.tag = num
        series.dataSource = self
        self.chartView.chart.addSeries(series)
    }
    
    func printThesaurus(n: Int, thesaurus: [String]) {
        var thesaurusStr = ""
        for word in thesaurus {
            thesaurusStr += " " + word + "  "
        }
        print("\n\(n) тезаурус:")
        print(thesaurusStr)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

//MARK:- NChartSeriesDataSource
extension ViewController: NChartSeriesDataSource {
    
    func seriesDataSourcePoints(for series: NChartSeries!) -> [Any]! {
        var points = [NChartPoint]()
        if series.tag > 0 && series.tag < 4 {
            let vectors = vectorsForSetsArray[series.tag - 1]
            for i in 0...3 {
                let vector = vectors[i]
                if let chartPoint = NChartPoint(state: NChartPointState(alignedToXZWithX: vector[0], y: Double(vector[1]), z: vector[2]), for: series) {
                    points.append(chartPoint)
                }
            }
            return points
        } else if series.tag > 10 {
            guard let centers = self.clusterCenters else { return [] }
            let index = series.tag % 10 - 1
            let center = centers[index]
            if let point = NChartPoint(state: NChartPointState(alignedToXZWithX: center[0], y: Double(center[1]), z: center[2]), for: series) {
                points.append(point)
            }
        }
        return points
    }
    
    func seriesDataSourceName(for series: NChartSeries!) -> String! {
        if series.tag > 0 && series.tag < 4 {
            return "\(series.tag) set"
        }
        return nil
    }
    
}
