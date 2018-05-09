//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hannes Jansen van Rensburg on 2018/05/09.
//  Copyright © 2018 Hannes Jansen van Rensburg. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // At runtime UIApplication = live app object
    // AppDelegate can access the objects of AppDelegate.swift file
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

     }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //This creates a reusable cell and adds it to the table at the indexpath
        //"CategoryCell" is the ID of prototype cell on CategoryViewController
        
        print("Setting cell values (using cellForRowAt)")
        cell.textLabel?.text = categoryArray[indexPath.row].name
        //cell.accessoryType = categoryArray[indexPath.row].done ? .checkmark : .none
        
        return cell //renders the cell on screen
    }

    
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            try context.save()
        } catch {
            print ("Error saving context, \(error)")
        }
        
        print("saved the updated categoryArray")
        
        tableView.reloadData() //refresh tableview from itemsArray
        //cause tableView(.., cellForRowAt ..) to run again
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        //request = name of paramenter used internal to loadItems
        //with = name of parameter used by code calling loadItems
        //Item.fetchRequest() = default used when no request is specified by calling code
        
        do {
            categoryArray = try context.fetch(request) //Returns an array
        } catch {
            print ("Error fetching data from context, \(error)")
        }
        
    }
    
    //MARK: - Add New Catagories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen hen the user clicks the add button on our UIAlert
            print("Success!")
            print(textField.text ?? "default value if textField.text is nil")
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            print("textfield added to alert")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods

    
}
