//
//  TextHandler.swift
//  Clustering
//
//  Created by Polina Dulko on 4/7/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation

class TextHandler {
    
    let thesaurusLength = 60
    
    func getStopWords() -> [String]? {
        guard let fileURL = Bundle.main.url(forResource: "stop", withExtension: "txt") else { return nil }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            guard let data = FileManager.default.contents(atPath: fileURL.path) else { return nil }
            guard let dataStr = String(data: data, encoding: .utf8) else { return nil }
            var wordsArray = dataStr.components(separatedBy: "\n")
            wordsArray.removeAll { (word) -> Bool in
                word == ""
            }
            var stopWordsArray = [String]()
            wordsArray.forEach { (word) in
                let stopWord = " " + word + " "
                stopWordsArray.append(stopWord)
            }
            return stopWordsArray
        }
        return nil
    }
    
    func getSetOfTexts(for title: String) -> String? {
        var allTexts = ""
        for i in 1...4 {
            let fileTitle = title.lowercased() + "_\(i)"
            guard let fileURL = Bundle.main.url(forResource: fileTitle, withExtension: "txt", subdirectory: title) else { return nil }
            if FileManager.default.fileExists(atPath: fileURL.path) {
                guard let data = FileManager.default.contents(atPath: fileURL.path) else { return nil }
                guard let dataStr = String(data: data, encoding: .utf8) else { return nil }
                allTexts += dataStr
            }
        }
        allTexts = allTexts.replacingOccurrences(of: "\n", with: " ")
        allTexts = allTexts.components(separatedBy: .decimalDigits).joined()
        var punctuationSet = CharacterSet.punctuationCharacters
        punctuationSet.remove("-")
        punctuationSet.remove("/")
        allTexts = allTexts.components(separatedBy: punctuationSet).joined()
        allTexts = allTexts.lowercased()
        guard let stopWords = getStopWords() else { return nil }
        for word in stopWords {
            allTexts = allTexts.replacingOccurrences(of: word, with: " ")
        }
        return allTexts
    }
    
    func createThesaurus(for text: String) -> [String] {
        let allWords = text.components(separatedBy: " ")
        var count = [String: Int]()
        for word in allWords {
            if count[word] == nil {
                count[word] = 1
            } else {
                count[word]! += 1
            }
        }
        let sortedCount = count.sorted { (first, second) -> Bool in
            first.value > second.value
        }
        let prefixCount = sortedCount.prefix(thesaurusLength)
        var mostFrequentWords = [String]()
        for item in prefixCount {
            if item.key != "" && item.key != "-" && item.key != "/" {
                mostFrequentWords.append(item.key)
            }
        }
        return mostFrequentWords
    }
    
    func getVectorsForSet(set title: String, clasteringHandler: ClasteringHandler?) -> [[Int]] {
        guard let clasteringHandler = clasteringHandler else { return [] }
        var vectorsForSet = [[Int]]()
        for i in 1...4 {
            let fileTitle = title.lowercased() + "_\(i)"
            guard let fileURL = Bundle.main.url(forResource: fileTitle, withExtension: "txt", subdirectory: title) else { return [] }
            if FileManager.default.fileExists(atPath: fileURL.path) {
                guard let data = FileManager.default.contents(atPath: fileURL.path) else { return [] }
                guard let dataStr = String(data: data, encoding: .utf8) else { return [] }
                if let vector = clasteringHandler.createVector(for: dataStr) {
                    vectorsForSet.append(vector)
                }
            }
        }
        return vectorsForSet
    }
    
}
