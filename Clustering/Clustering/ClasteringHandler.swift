//
//  ClasteringHandler.swift
//  Clustering
//
//  Created by Polina Dulko on 4/7/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation

class ClasteringHandler {
    
    var firstThesaurus: [String]?
    var secondThesaurus: [String]?
    var thirdThesaurus: [String]?
    
    init(firstThesaurus: [String], secondThesaurus: [String], thirdThesaurus: [String]) {
        self.firstThesaurus = firstThesaurus
        self.secondThesaurus = secondThesaurus
        self.thirdThesaurus = thirdThesaurus
    }
    
    func createVector(for text: String) -> [Int]? {
        guard let firstThesaurus = firstThesaurus, let secondThesaurus = secondThesaurus, let thirdThesaurus = thirdThesaurus else { return nil }
        let allWords = text.components(separatedBy: " ")
        
        var sum1 = 0
        var sum2 = 0
        var sum3 = 0
        for word in allWords {
            if firstThesaurus.contains(word) {
                sum1 += 1
            }
            if secondThesaurus.contains(word) {
                sum2 += 1
            }
            if thirdThesaurus.contains(word) {
                sum3 += 1
            }
        }
        return [sum1, sum2, sum3]
    }
    
}
