//
//  DictionaryKeysTableViewController.swift
//  CompoundWords
//
//  Created by soma gorinta on 10/4/18.
//  Copyright © 2018 soma gorinta. All rights reserved.
//

import UIKit

class DictionaryKeysTableViewController: UITableViewController {
    let fileName:String = "english"
    var values:Array<String> = []
    var jsonData:Dictionary<String, Array<String>> = [:]
    var compundWords:Array<String> = []
    let checker: UITextChecker = UITextChecker()
    
    var selectCompoundWords:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            self.readValuesFromJson()
            self.findCompoundWordsFromValues()
        }
        
    }
    
    func readValuesFromJson() {
        let data = self.readDataFromJsonFile(fileName: self.fileName)
        
        if data.errorKey == nil {
            if let jsonData = data.Data {
                self.jsonData = jsonData
                self.values = Array(jsonData.keys)
                self.values = Array(Set(self.values))
                
                self.values = self.values.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                
                print(self.values.count)
            }
        }
    }
    
    func readDataFromJsonFile(fileName:String) -> (errorKey:String?, Data:Dictionary<String, Array<String>>?) {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, Array<String>> {
                    return (nil,jsonResult)
                }
            } catch {
                // handle error
                return (error.localizedDescription, nil)
            }
        }
        else {
            return ("file not found", nil)
        }
        return (nil, nil)
    }
    
    func findCompoundWordsFromValues() {
        for eachValue in self.values {
            if self.checkWordIsCompoundWord(word: eachValue) {
                if self.compundWords.contains(eachValue) {
                }
                else {
                    self.compundWords.append(eachValue)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: IndexPath.init(row: self.compundWords.count-1, section: 0), at: .bottom, animated: true)
                    }
                }
            }
        }
    }
    
    func checkWordIsCompoundWord(word:String) -> Bool {
        for i in 1..<word.count {
            let word0 = word.prefix(i)
            let word1 = word.suffix(word.count-i)
            
            if word0.count > 1 && word1.count > 1 {
                // let filtered0 = self.values.filter { $0.hasPrefix(word0) }
                if isWordExistsInKeys(word: String(word0)) {
                    if isWordExistsInKeys(word: String(word1)) {
                        print("\(word0) + \(word1)")
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func isWordExistsInKeys(word:String) -> Bool {
        if self.values.contains(where: {$0.caseInsensitiveCompare(word) == .orderedSame}) {
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return compundWords.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CompoundWordTableViewCell
        
        cell.labelText?.text = compundWords[indexPath.row]
        
        return cell
    }
    
}
extension Array where Element: Equatable {
    
}
