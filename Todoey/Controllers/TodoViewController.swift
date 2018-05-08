//
//  ViewController.swift
//  Todoey
//
//  Created by Hannes Jansen van Rensburg on 2018/05/03.
//  Copyright © 2018 Hannes Jansen van Rensburg. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    
    //var itemsArray = ["Cell 1","Cell 2","Cell 3"]
    var itemsArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // At runtime UIApplication = live app object
    // AppDelegate can access the objects of AppDelegate.swift file
    
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //look in .userDomainMask (user's home directory - personal items assosiated with this app)
    //this is an array - .first picks the first item in the array
    //.appendingPathComponent("Items.plist") just creates path - not the file

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath ?? "dataFilePath was not available") //default value
        
        loadItems()
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemsArray = items
//            print("itemsArray use TodoListArray in defaults")
//        } else {
//            print("TodoListArray using hardcoded items")
//        }
        
        
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
        saveItems() //save item.done that was changed
        
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
            
            //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            // At runtime UIApplication = live app object
            // AppDelegate can access the objects of AppDelegate.swift file
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text! //mandatory field as per DB
            newItem.done = false //mandatory field as per DB
            self.itemsArray.append(newItem)

            //self.defaults.set(self.itemsArray, forKey: "TodoListArray") //save the updated itemsArray to defaults (UserDefaults)
            self.saveItems()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("textfield added to alert")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
    func saveItems() {
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            try context.save()
        } catch {
            print ("Error saving context, \(error)")
        }
        
        print("saved the updated itemsArray to TodoListArray in defaults")
        
        tableView.reloadData() //refresh tableview from itemsArray
        //cause tableView(.., cellForRowAt ..) to run again

    }

    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //NSFetchRequest<Item> specifies the datatype of the output - in this case Item
        do {
            itemsArray = try context.fetch(request) //Returns an array
        } catch {
            print ("Error fetchin data from context, \(error)")
        }
        
     }

}

