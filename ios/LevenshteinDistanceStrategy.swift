//
//  LevenshteinDistanceStrategy.swift
//  react-native-mad-ocr
//
//  Created by Trond Eskeland on 09/09/2020.
//

import Foundation
import UIKit

class LevenshteinDistanceStrategy: OcrStrategy {
    private var knownTags = [String]()
    private let helper = Helper()
    
    init(knownTags: [String]) {
        self.knownTags = knownTags
    }
    func extractTags(tags: [String]) -> [String] {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // If knownTags is empty
        if knownTags.count == 0 {
            return tags
        }
        
        
        var result = [String]()
        for tag in tags {
            if knownTags.contains(tag) {
                result.append(tag)
            } else {
                var matches = [TagMatch]()
          
                for knownTag in knownTags {
                    let matchRate = simularity(source: tag, other: knownTag)
                    matches.append(TagMatch(tag: knownTag, matchRate: matchRate))
                }
                
                let sortedMatches = matches.sorted(by: { $0.matchRate > $1.matchRate })
                
                let bestMatch = sortedMatches.first
                
                if let bestMatch = bestMatch {
                    if sortedMatches.count > 2 {
                        let firstMatch = sortedMatches[0]
                        let secoundMatch = sortedMatches[1]
                        
                        if firstMatch.matchRate != secoundMatch.matchRate {
                            result.append(bestMatch.tag)
                        } else {
                            // no good match found, adding the tag from ocr.
                            result.append(tag)
                        }
                    } else {
                        result.append(bestMatch.tag)
                    }
                    
                    
                } else {
                    result.append(tag)
                }
            }
            
            
        }
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
          print("Time elapsed for LevenshteinDistanceStrategy: \(timeElapsed) s.")
        
        return result
    }
    
    
    
    func simularity(source: String, other: String) -> Double {
        // Using objective-c implementations because it's 3.5 x faster than swift (related to string comparing)
        let stepsToSame = helper.computeLevenshteinDistance(from: source, to: other);
        return 1.0 - (Double(stepsToSame) / Double(max(source.count, other.count)));
    }
    

    
}

class TagMatch {
    init(tag: String, matchRate: Double) {
        self.tag = tag
        self.matchRate = matchRate
    }
    let tag:String
    let matchRate:Double

}


//extension String {
//
//    func levenshteinDistanceScore(to string: String) -> Double {
//
//        let firstString = self
//        let secondString = string
//
//        let empty = [Int](repeating:0, count: secondString.count)
//        var last = [Int](0...secondString.count)
//
//        for (i, tLett) in firstString.enumerated() {
//            var cur = [i + 1] + empty
//            for (j, sLett) in secondString.enumerated() {
//                cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j])+1
//            }
//            last = cur
//        }
//
//        // maximum string length between the two
//        let lowestScore = max(firstString.count, secondString.count)
//
//        if let validDistance = last.last {
//            return  1 - (Double(validDistance) / Double(lowestScore))
//        }
//
//        return 0.0
//    }
//
//}

