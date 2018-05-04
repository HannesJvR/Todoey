//
//  ViewController.swift
//  Todoey
//
//  Created by Hannes Jansen van Rensburg on 2018/05/03.
//  Copyright © 2018 Hannes Jansen van Rensburg. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    let itemsArray = ["Cell 1","Cell 2","Cell 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemsArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none // remove checkmark for cell
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark // show checkmark for cell
        }
        
        tableView.deselectRow(at: indexPath, animated: true) // show selected row only briefly
    }


}

