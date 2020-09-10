//
//  ShortTextStrategy.swift
//  react-native-mad-ocr
//
//  Created by Trond Eskeland on 10/09/2020.
//

import Foundation

class ShortTextStrategy: OcrStrategy {
    
    func extractTags(tags: [String]) -> [String] {
        var result = [String]()
        
        for tag in tags {
            if tag.count >= 5 {
                result.append(tag)
            }
            
        }
        
        return result
    }
}
