//
//  ViewController.swift
//  Clustering
//
//  Created by Polina Dulko on 4/7/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let textHandler = TextHandler()
    let setTitles = ["Networking", "Medicine", "Sociology"]
    var thesaurusArray = [[String]]()
    var vectorsForSetsArray = [[[Int]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...2 {
            guard let setOfTexts = textHandler.getSetOfTexts(for: setTitles[i]) else { return }
            thesaurusArray.append(textHandler.createThesaurus(for: setOfTexts))
            printThesaurus(n: i + 1, thesaurus: thesaurusArray[i])
        }
        
        let clasteringHandler = ClasteringHandler(firstThesaurus: thesaurusArray[0], secondThesaurus: thesaurusArray[1], thirdThesaurus: thesaurusArray[2])
        for i in 0...2 {
            let vectorsForSet = textHandler.getVectorsForSet(set: setTitles[i], clasteringHandler: clasteringHandler)
            print("\nВектора признаков \(i + 1):")
            for vector in vectorsForSet {
                print(vector)
            }
            vectorsForSetsArray.append(vectorsForSet)
        }
        
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

