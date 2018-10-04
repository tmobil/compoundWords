//
//  ViewController.swift
//  CompoundWords
//
//  Created by soma gorinta on 10/3/18.
//  Copyright © 2018 soma gorinta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var compundWords:Array<String> = []
    let checker: UITextChecker = UITextChecker()

    @IBOutlet weak var processingView: UIView!
    @IBOutlet weak var lblProcessingText: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    let fileName:String = "english"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            
            self.lblProcessingText.text = "Please wait we are reading your file."
            self.activityView.startAnimating()
        }
        
        DispatchQueue.global().async {
            let data = self.readDataFromJsonFile(fileName: self.fileName)
            
            if data.errorKey == nil {
                DispatchQueue.main.async {
                    
                    self.lblProcessingText.text = "Please wait we are Processing the data."
                    self.activityView.startAnimating()
                }
                
                if let jsonData = data.Data {
                    for eachValueInJson in jsonData.values {
                        for value in eachValueInJson {
                            let formattedWord = self.removeSpecialCharsFromString(text: value)
                            self.checkForWordsInString(sentence: formattedWord)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.lblProcessingText.text = "Compound words are genearated and printed in the console."
                    self.activityView.stopAnimating()
                }
                
                print(self.compundWords)
            }
        }
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

}

