//
//  LevenshteinDistanceStrategy.swift
//  react-native-mad-ocr
//
//  Created by Trond Eskeland on 09/09/2020.
//

import Foundation

class LevenshteinDistanceStrategy: OcrStrategy {
    private var knownTags = [String]()
    init(knownTags: [String]) {
        self.knownTags = knownTags
    }
    func extractTags(tags: [String]) -> [String] {
        var result = [String]()
        for tag in tags {
            if knownTags.contains(tag) {
                result.append(tag)
            } else {
                var matches = [TagMatch]()
                for knownTag in knownTags {
                    // let matchRate = simularity(source: tag, other: knownTag)
                    let matchRate = tag.levenshteinDistanceScore(to: knownTag, ignoreCase: false, trimWhiteSpacesAndNewLines: true)
                    matches.append(TagMatch(tag: knownTag, matchRate: matchRate))
                }
                
                let sortedMatches = matches.sorted(by: { $0.matchRate > $1.matchRate })
                
                let bestMatch = sortedMatches.first
                
                if let bestMatch = bestMatch {
                    result.append(bestMatch.tag)
                } else {
                    result.append(tag)
                }
            }
            
            
        }
        return result
    }
    
    
    
    func simularity(source: String, other: String) -> Double {
        let stepsToSame = other.levenshtein(other)
        
        return (1.0 - (Double(stepsToSame) / Double(max(source.count, other.count))));
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

extension String {
    subscript(index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}

extension String {
    
    func levenshteinDistanceScore(to string: String, ignoreCase: Bool = true, trimWhiteSpacesAndNewLines: Bool = true) -> Double {

        var firstString = self
        var secondString = string

        if ignoreCase {
            firstString = firstString.lowercased()
            secondString = secondString.lowercased()
        }
        if trimWhiteSpacesAndNewLines {
            firstString = firstString.trimmingCharacters(in: .whitespacesAndNewlines)
            secondString = secondString.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        let empty = [Int](repeating:0, count: secondString.count)
        var last = [Int](0...secondString.count)

        for (i, tLett) in firstString.enumerated() {
            var cur = [i + 1] + empty
            for (j, sLett) in secondString.enumerated() {
                cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j])+1
            }
            last = cur
        }

        // maximum string length between the two
        let lowestScore = max(firstString.count, secondString.count)

        if let validDistance = last.last {
            return  1 - (Double(validDistance) / Double(lowestScore))
        }

        return 0.0
    }
    
    public func levenshtein(_ other: String) -> Int {
        let sCount = self.count
        let oCount = other.count

        guard sCount != 0 else {
            return oCount
        }

        guard oCount != 0 else {
            return sCount
        }

        let line : [Int]  = Array(repeating: 0, count: oCount + 1)
        var mat : [[Int]] = Array(repeating: line, count: sCount + 1)

        for i in 0...sCount {
            mat[i][0] = i
        }

        for j in 0...oCount {
            mat[0][j] = j
        }

        for j in 1...oCount {
            for i in 1...sCount {
                if self[i - 1] == other[j - 1] {
                    mat[i][j] = mat[i - 1][j - 1]       // no operation
                }
                else {
                    let del = mat[i - 1][j] + 1         // deletion
                    let ins = mat[i][j - 1] + 1         // insertion
                    let sub = mat[i - 1][j - 1] + 1     // substitution
                    mat[i][j] = min(min(del, ins), sub)
                }
            }
        }

        return mat[sCount][oCount]
    }
}
