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
    
        for i in 1...3 {
            addSeriesToChart(num: i)
        }
        self.chartView.chart.updateData()
    }
    
    func createMarker(color: NSColor) -> NChartMarker {
        let marker = NChartMarker()
        marker.brush = NChartSolidColorBrush(color: color)
        marker.shape = NChartMarkerShape.circle
        marker.size = 8
        return marker
    }
    
    func addSeriesToChart(num: Int) {
        let series = NChartBubbleSeries()
        var markerColor = NSColor.black
        if num == 1 {
            markerColor = NSColor(displayP3Red: 140/255, green: 25/255, blue: 88/255, alpha: 1.0)
        } else if num == 2 {
            markerColor = NSColor(displayP3Red: 25/255, green: 146/255, blue: 46/255, alpha: 1.0)
        } else if num == 3 {
            markerColor = NSColor(displayP3Red: 194/255, green: 0/255, blue: 13/255, alpha: 1.0)
        }
        series.marker = createMarker(color: markerColor)
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
        if series.tag >= 1 && series.tag <= 3 {
            let vectors = vectorsForSetsArray[series.tag - 1]
            var points = [NChartPoint]()
            for i in 0...3 {
                let vector = vectors[i]
                if let chartPoint = NChartPoint(state: NChartPointState(alignedToXZWithX: vector[0], y: Double(vector[1]), z: vector[2]), for: series) {
                    points.append(chartPoint)
                }
            }
            return points
        }
        return []
    }
    
    func seriesDataSourceName(for series: NChartSeries!) -> String! {
        return "\(series.tag) set"
    }
    
}
