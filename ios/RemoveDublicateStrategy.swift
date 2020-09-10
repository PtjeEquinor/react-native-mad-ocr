//
//  RemoveDublicateStrategy.swift
//  react-native-mad-ocr
//
//  Created by Trond Eskeland on 10/09/2020.
//

import Foundation

class RemoveDublicateStrategy: OcrStrategy {
    
    func extractTags(tags: [String]) -> [String] {
        let result = tags.uniqued()
        
        return result
    }
}


public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
