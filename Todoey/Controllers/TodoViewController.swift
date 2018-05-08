//
//  ViewController.swift
//  Todoey
//
//  Created by Hannes Jansen van Rensburg on 2018/05/03.
//  Copyright © 2018 Hannes Jansen van Rensburg. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    //var itemsArray = ["Cell 1","Cell 2","Cell 3"]
    var itemsArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemsArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemsArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogoron"
        itemsArray.append(newItem3)
        

        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemsArray = items
            print("itemsArray use TodoListArray in defaults")
        } else {
            print("TodoListArray using hardcoded items")
        }
        
        
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        print("Setting cell values (using cellForRowAt)")
        cell.textLabel?.text = itemsArray[indexPath.row].title
        
//        if itemsArray[indexPath.row].done {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        cell.accessoryType = itemsArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemsArray[indexPath.row])
        
        itemsArray[indexPath.row].done = !(itemsArray[indexPath.row].done) //Toggle the done value
        
        tableView.reloadData() //cause tableView(.., cellForRowAt ..) to run again

// Now being set as part of override func tableView based on itemsArray values
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none // remove checkmark for cell
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark // show checkmark for cell
//        }
        
        tableView.deselectRow(at: indexPath, animated: true) // show selected row only briefly
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen hen the user clicks the add button on our UIAlert
            print("Success!")
            print(textField.text ?? "default value if textField.text is nil")
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemsArray.append(newItem)

            self.defaults.set(self.itemsArray, forKey: "TodoListArray") //save the updated itemsArray to defaults (UserDefaults)
            print("saved the updated itemsArray to TodoListArray in defaults")

            self.tableView.reloadData() //refresh tableview from itemsArray
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("textfield added to alert")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }


}

