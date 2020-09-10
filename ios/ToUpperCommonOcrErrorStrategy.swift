//
//  ToUpperCommonOcrErrorStrategy.swift
//  react-native-mad-ocr
//
//  Created by Trond Eskeland on 10/09/2020.
//

import Foundation

class ToUpperCommonOcrErrorStrategy: OcrStrategy {
    
    private var regexPattern = #"(?=.*\d)[A-Z0-9-]+[ ]?[l]{1,1}[ ]?[A-Z0-9]+"#
    
    func extractTags(tags: [String]) -> [String] {
        var result = tags
        
        
        let regex = try! NSRegularExpression(pattern: regexPattern)
        
        for tag in tags {
            let matches = regex.matches(in: tag, options: [], range: NSRange(location: 0, length: tag.count))
            
            if matches.count > 0 {
                let range = matches[0].range(at: 0)
                let start = tag.index(tag.startIndex, offsetBy: range.location)
                let end = tag.index(tag.startIndex, offsetBy: range.location + range.length)
                
                let foundTag = tag[start..<end]
                result.append(String(foundTag).uppercased())
            }
            
        }
        
        return result
    }
}
