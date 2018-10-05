//
//  CompoundWordsTableViewController.swift
//  CompoundWords
//
//  Created by soma gorinta on 10/4/18.
//  Copyright © 2018 soma gorinta. All rights reserved.
//

import UIKit

class CompoundWordsTableViewController: UITableViewController {
    var compundWords:Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()

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
        if compundWords.count > 0 {
            return compundWords.count
        }
       return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CompoundWordTableViewCell
        
        if compundWords.count > 0 {
            cell.labelText?.text = compundWords[indexPath.row]
        }
        else {
            cell.labelText?.text = "No compound words available in selected key"
        }
        return cell
    }
}
