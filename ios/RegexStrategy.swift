//
//  RegexStrategy.swift
//  react-native-mad-ocr
//
//  Created by Trond Eskeland on 10/09/2020.
//

import Foundation
class RegexStrategy: OcrStrategy {
    private var regexPattern = #"([A-Z]{1,2}\d{1}[A-Z0-9]{6,8})|(\d{1,2}""[A-Z]{2,4}[A-Z\d]{4,12})|((?=.*\d)\d?[A-Z]{1,4}[A-Z\d]{4,12})|((?=.*\d)[A-ZÆØÅ\d,\/\.\""\-]{1,12}[ ]{0,2}[\-+\.\/_ ][ ]{0,2}[A-ZÆØÅ\d\.&\""]{1,10}([ ]{0,2}[+\-_= ][A-ZÆØÅ\d]{1,12}){0,6})|([A-ZÆØÅ\d,\/\.\""\-]{1,12}[\-+\.\/_][A-ZÆØÅ\d\.&\""]{1,10}([+\-_=][A-ZÆØÅ\d]{1,12}){0,6})|(\d{2,2}[A-Z][A-Z\d]{2,7})|(\d{1,2}[A-Z]{2,2}[_]{1,5}\d{2,4})|([A-Z]{3,3}\d\(\d{1,2}\))"#

    
    func extractTags(tags: [String]) -> [String] {
        var result = [String]()
        
        
        let regex = try! NSRegularExpression(pattern: regexPattern)
        
        for tag in tags {
            let matches = regex.matches(in: tag, options: [], range: NSRange(location: 0, length: tag.count))
            
            if matches.count > 0 {
                let range = matches[0].range(at: 0)
                let start = tag.index(tag.startIndex, offsetBy: range.location)
                let end = tag.index(tag.startIndex, offsetBy: range.location + range.length)
                
                let foundTag = tag[start..<end]
                result.append(String(foundTag))
            }
            
        }
        
        return result
    }
    
    

    

}
