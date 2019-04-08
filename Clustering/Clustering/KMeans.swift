//
//  KMeans.swift
//  Clustering
//
//  Created by Polina Dulko on 4/8/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation

class KMeans {
    
    let k = 3
    var data = [[Int]]()
    var centroids = [[Int]]()
    var clusters = [Int]()
    var sumOfDistances = 0.0
    
    func train(vectors: [[[Int]]]) -> ([[Int]], [[[Int]]]) {
        var data = [[Int]]()
        for group in vectors {
            for vector in group {
                data.append(vector)
            }
        }
        self.data = data
        let n = data.count
        clusters = [Int](repeating: 0, count: n)
        if k == n {
            centroids = data
            return (centroids, vectors)
        }
        
        let index = Int(arc4random() % 3)
        for i in 0...2 {
            centroids.append(data[index + i * 4])
        }
        var isCovergenceReached = false
        print("\nK-means")
        
        while !isCovergenceReached {
            sumOfDistances = 0.0
            
            //Divide on clusters
            clusters = [Int](repeating: 0, count: data.count)
            for i in 0...data.count - 1 {
                var minDistance = Double.infinity
                for j in 0...2 {
                    let distance = distanceTo(vector1: data[i], vector2: centroids[j])
                    if distance < minDistance {
                        clusters[i] = j
                        minDistance = distance
                    }
                }
                sumOfDistances += minDistance
            }
            
            print("\nРазделение на кластеры (s = \(Int(sumOfDistances))):")
            print(clusters)
            print("Центры кластеров:")
            print(centroids)
            
            //Calculate new centroids
            var newCentroids = [[Int]]()
            for i in 0...2 {
                var newCenterX = 0
                var newCenterY = 0
                var newCenterZ = 0
                var count = 0
                for j in 0...data.count - 1 {
                    if clusters[j] == i {
                        newCenterX += data[j][0]
                        newCenterY += data[j][1]
                        newCenterZ += data[j][2]
                        count += 1
                    }
                }
                newCentroids.append([newCenterX / count, newCenterY / count, newCenterZ / count])
            }
            
            if newCentroids == centroids {
                isCovergenceReached = true
            } else {
                centroids = newCentroids
            }
        }
        
        var newVectors = [[[Int]]](repeating: [[Int]](), count: 3)
        for i in 0...data.count - 1 {
            let cluster = clusters[i]
            newVectors[cluster].append(data[i])
        }
        return (centroids, newVectors)
    }
    
    func distanceTo(vector1: [Int], vector2: [Int]) -> Double {
        let xDiff = pow(Double(vector1[0] - vector2[0]), 2)
        let yDiff = pow(Double(vector1[1] - vector2[1]), 2)
        let zDiff = pow(Double(vector1[2] - vector2[2]), 2)
        return sqrt(xDiff + yDiff + zDiff)
    }
    
    func defineClaster(for vector: [Int]) -> Int {
        var clusterIndex = 0
        var minDistance = Double.infinity
        print("\nРасстояния до центров кластеров:")
        for i in 0...2 {
            let distance = distanceTo(vector1: vector, vector2: centroids[i])
            print("\(i + 1) - \(Int(distance))")
            if distance < minDistance {
                clusterIndex = i + 1
                minDistance = distance
            }
        }
        return clusterIndex
    }
    
}
