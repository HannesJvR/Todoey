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
    
    var selectedCategory : Category? {
        didSet{ //is triggered when a value for selectedCategory is set
            print("Category \(selectedCategory!.name ?? "<none>") was detected by TodoViewController.")
            loadItems()
        }
    }
    //Optional because it will be nil until segue is performed
    //This is set by delegate method in CategoryViewController
    
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
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //This creates a reusable cell and adds it to the table at the indexpath
        //"ToDoItemCell" is the ID of prototype cell on TodoViewController
        
        print("Setting cell values (using cellForRowAt)")
        cell.textLabel?.text = itemsArray[indexPath.row].title
        cell.accessoryType = itemsArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemsArray[indexPath.row])
        
        itemsArray[indexPath.row].done = !(itemsArray[indexPath.row].done) //Toggle the done value
        saveItems() //save item.done that was changed
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text! //mandatory field as per DB
            newItem.done = false //mandatory field as per DB
            newItem.parentCategory = self.selectedCategory
            self.itemsArray.append(newItem)
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
        
        print("saved the updated itemsArray")
        
        tableView.reloadData() //refresh tableview from itemsArray
        //cause tableView(.., cellForRowAt ..) to run again

    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ) {
        //request = name of paramenter used internal to loadItems
        //with = name of parameter used by code calling loadItems
        //Item.fetchRequest() = default used when no request is specified by calling code
        //predicate is second parameter set as optional with nil as default
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory!.name!))
        
        if let addionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addionalPredicate]) //use 2 predicates if predicate parameter is specified (for search criteria)
            print("request.predicate = <\(request.predicate!)>")
        } else {
            request.predicate = categoryPredicate //use 1 predicate
        }
        
        do {
            itemsArray = try context.fetch(request) //Returns an array
        } catch {
            print ("Error fetchin data from context, \(error)")
        }
        
        tableView.reloadData()
        
     }
    
}

//MARK: - Search bar methods
// using extension for delegate functions helps to modularise the code
// UITableViewController can be handled in a similar way
extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBar.text = <\(searchBar.text!)>")
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //this replace %@ with searchBar.text when running query against DB
        //[cd] indicates it is not case sensitive or diacretic sensitive
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //this array may contain multiple sort descriptors
        
        print("searchPredicate = <\(searchPredicate)>")
        loadItems(with: request, predicate: searchPredicate)
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

