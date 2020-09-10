//
//  FilterCharUniqStrategy.swift
//  react-native-mad-ocr
//
//  Created by Trond Eskeland on 10/09/2020.
//

import Foundation

class FilterCharUniqStrategy: OcrStrategy {
    
    func extractTags(tags: [String]) -> [String] {
        var result = [String]()
        
        for tag in tags {
            let chars = Array(tag)
            var allCharsIsEqual = true
            for i in 0..<chars.count {
                if chars[0] != chars[i] {
                    allCharsIsEqual = false
                    break
                }
            }
            
            if !allCharsIsEqual {
                result.append(tag)
            }
        }
        
        return result
    }
}
