//
//  ViewController.swift
//  Todoey
//
//  Created by Hannes Jansen van Rensburg on 2018/05/03.
//  Copyright © 2018 Hannes Jansen van Rensburg. All rights reserved.
//

import UIKit
import RealmSwift

class TodoViewController: UITableViewController {
    
    var selectedCategory : Category? {
        didSet{ //is triggered when a value for selectedCategory is set
            print("Category \(selectedCategory!.name) was detected by TodoViewController.")
            loadItems()
        }
    }
    //Optional because it will be nil until segue is performed
    //This is set by delegate method in CategoryViewController
    
    let realm = try! Realm()
    
    var itemResults : Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //This creates a reusable cell and adds it to the table at the indexpath
        //"ToDoItemCell" is the ID of prototype cell on TodoViewController
        
        if let item = itemResults?[indexPath.row] {
            print("Setting cell values (using cellForRowAt)")
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items found"
        }
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemResults![indexPath.row])
        
        print("Updating done indicator...")
        if let item = itemResults?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
//        itemResults[indexPath.row].done = !(itemResults[indexPath.row].done) //Toggle the done value
//        saveItems() //save item.done that was changed
        
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text! //mandatory field as per DB
                        //newItem.done = false //default already set as part of Data Model
                        //newItem.parentCategory = self.selectedCategory
                        //self.itemResults.append(newItem)
                        currentCategory.items.append(newItem)
                        //self.saveItems()
                    }
                    
                } catch {
                    print("Error saving new items, \(error)")
                }
                
                self.tableView.reloadData()
 
            }
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
        
        print("saved the updated itemResults")
        
        tableView.reloadData() //refresh tableview from itemResults
        //cause tableView(.., cellForRowAt ..) to run again

    }

    func loadItems() {
        itemResults = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
     }
    
}

//MARK: - Search bar methods
// using extension for delegate functions helps to modularise the code
// UITableViewController can be handled in a similar way
extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBar.text = <\(searchBar.text!)>")
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        //this replace %@ with searchBar.text when running query against DB
//        //[cd] indicates it is not case sensitive or diacretic sensitive
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //this array may contain multiple sort descriptors
//
//        print("searchPredicate = <\(searchPredicate)>")
//        loadItems(with: request, predicate: searchPredicate)
        print("Completed execution of loadItems")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //This return screen to the state before the search funtionality was called
        if searchBar.text?.count == 0 {
            //searchBar.text?.count = length of search text
            loadItems()
            
            DispatchQueue.main.async { //Grab the main execution thread
                searchBar.resignFirstResponder() //return to status before searchBar was activated
            }
        }
    }

}

