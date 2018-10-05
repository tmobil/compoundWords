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
    var dictionaryKeys:Array<String> = []
    var jsonData:Dictionary<String, Array<String>> = [:]
    var compundWords:Array<String> = []
    let checker: UITextChecker = UITextChecker()
    
    var selectCompoundWords:Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            let data = self.readDataFromJsonFile(fileName: self.fileName)
            
            if data.errorKey == nil {
                if let jsonData = data.Data {
                    self.jsonData = jsonData
                    self.dictionaryKeys = Array(jsonData.keys)
                    self.dictionaryKeys = self.dictionaryKeys.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    for eachValueInJson in jsonData.values {
                        for value in eachValueInJson {
                            let formattedWord = self.removeSpecialCharsFromString(text: value)
                            self.checkForWordsInString(sentence: formattedWord)
                        }
                    }
                }
                
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
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    func checkForWordsInString(sentence:String) {
        let words:Array<String> = sentence.components(separatedBy: " ")
        
        for eachWord in words {
            if eachWord.count > 1 {
                if compundWords.contains(eachWord){
                    //do nothing
                }
                else {
                    if checkWordIsCompoundWord(word: eachWord) {
                        compundWords.append(eachWord)
                    }
                }
                
            }
        }
    }
    
    func checkWordIsCompoundWord(word:String) -> Bool {
        if word.count < 4 {
            return false
        }
        for i in 1..<word.count {
            let word0 = word.prefix(i)
            let word1 = word.suffix(word.count-i)
            
            if word0.count > 1 && word1.count > 1 {
                if isWordValid(word: String(word0)) && isWordValid(word: String(word1)) {
                    return true
                }
            }
        }
        return false
    }
    
    func isWordValid(word:String) -> Bool {
        let range: NSRange = NSRange(location: 0,length: word.count)
        let misspelledRange: NSRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en_US")
        return  misspelledRange.location == NSNotFound
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return dictionaryKeys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CompoundWordTableViewCell
        
        if indexPath.section == 0 {
            cell.labelText?.text = "Load all compound words from dictionary"
        }
        else {
            cell.labelText?.text = dictionaryKeys[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var tableHeaderView:UIView = UIView()
        var headerLabel:UILabel = UILabel()
        
        tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 30))
        tableHeaderView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        headerLabel = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: self.tableView.frame.size.width-40, height: 30))
        if section == 0 {
            headerLabel.text = "All Compound Words"
        }
        else {
            headerLabel.text = "Select any key to see compound words in it"
        }
        
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.textColor = UIColor.black
        headerLabel.font = UIFont.boldSystemFont(ofSize: 17)
        tableHeaderView.addSubview(headerLabel)
        
        return tableHeaderView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let compundTableVC:CompoundWordsTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "CompoundTableVC") as! CompoundWordsTableViewController
        
        if indexPath.section == 0 {
            compundTableVC.compundWords = self.compundWords
            compundTableVC.title = "All Compound Words"
        }
        else {
            selectCompoundWords = []
            let values = jsonData[dictionaryKeys[indexPath.row]]
            for value in values! {
                let formattedWord = self.removeSpecialCharsFromString(text: value)
                let words:Array<String> = formattedWord.components(separatedBy: " ")
                
                for eachWord in words {
                    if eachWord.count > 1 {
                        if selectCompoundWords.contains(eachWord){
                            //do nothing
                        }
                        else {
                            if checkWordIsCompoundWord(word: eachWord) {
                                selectCompoundWords.append(eachWord)
                            }
                        }
                        
                    }
                }
            }
            compundTableVC.compundWords = selectCompoundWords
            compundTableVC.title = dictionaryKeys[indexPath.row]

        }
        self.navigationController?.pushViewController(compundTableVC, animated: true)
    }

}
