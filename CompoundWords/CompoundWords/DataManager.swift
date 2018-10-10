//
//  DataManager.swift
//  CompoundWords
//
//  Created by soma gorinta on 10/4/18.
//  Copyright © 2018 soma gorinta. All rights reserved.
//

import Foundation

class DataManager {
    static let manager = DataManager()
    private init() {}
    
    var compoundWords = [String]()
    var count: Int {
        return compoundWords.count
    }
    
    func findCompoundWordsFromValues(jsonFile: String, onComplete: @escaping (_ status: Bool) -> Void) {
        if let path = Bundle.main.url(forResource: jsonFile, withExtension: "json") {
            do {
                compoundWords.removeAll()
                let data = try Data(contentsOf: path)
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] {
                    let allKeys = Array(jsonResult.keys).sorted().filter{ !($0.hasPrefix("'")) && !($0.hasPrefix("-")) && !($0.hasPrefix(",")) && ($0.count > 1) }
                    let lowerCaseAllKeys = allKeys.map{ $0.lowercased() }
                    
                    for firstLocation in 0..<allKeys.count {
                        print("First location: \(firstLocation)")
                        for secondLocation in 0..<(allKeys.count - 1) {
                            if firstLocation == secondLocation {
                                continue
                            }
                            
                            let testWord = (allKeys[firstLocation] + allKeys[secondLocation]).lowercased()
                            if let index = lowerCaseAllKeys.firstIndex(of: testWord), !self.compoundWords.contains(allKeys[index]) {
                                self.compoundWords.append(allKeys[index])
                                onComplete(true)
                            }
                        }
                    }
                    
                    onComplete(true)
                } else {
                    onComplete(false)
                }
            } catch {
                onComplete(false)
                print("Error in handling json file: \(error.localizedDescription)")
            }
        } else {
            onComplete(false)
        }
    }
    
    func getWord(at index: Int) -> String {
        return compoundWords[index]
    }
}
