//
//  DictionaryKeysTableViewController.swift
//  CompoundWords
//
//  Created by soma gorinta on 10/4/18.
//  Copyright © 2018 soma gorinta. All rights reserved.
//

import UIKit

class DictionaryKeysTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            DataManager.manager.findCompoundWordsFromValues(jsonFile: "english", onComplete: { (status) in
                DispatchQueue.main.async {
                    if status {
                        self.tableView.reloadData()
                    } else {
                        let alert = UIAlertController(title: "Warning", message: "Failed to read and parse the json", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = DataManager.manager.count
        return count == 0 ? 1 : count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        if DataManager.manager.count == 0 {
            cell.textLabel?.text = "Preparing....."
        } else {
            cell.textLabel?.text = DataManager.manager.getWord(at: indexPath.row)
        }
        
        return cell
    }
}
