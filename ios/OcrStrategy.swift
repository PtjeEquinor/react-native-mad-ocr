//
//  OcrStrategy.swift
//  react-native-mad-ocr
//
//  Created by Trond Eskeland on 09/09/2020.
//

import Foundation

protocol OcrStrategy {
    func extractTags(tags: [String]) -> [String]
}
