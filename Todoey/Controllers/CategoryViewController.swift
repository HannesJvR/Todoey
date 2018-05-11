//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hannes Jansen van Rensburg on 2018/05/09.
//  Copyright © 2018 Hannes Jansen van Rensburg. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryResults: Results<Category>?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // At runtime UIApplication = live app object
    // AppDelegate can access the objects of AppDelegate.swift file
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

     }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryResults?.count ?? 1 //?? - nil coalescing operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //This creates a reusable cell and adds it to the table at the indexpath
        //"CategoryCell" is the ID of prototype cell on CategoryViewController
        
        print("Setting cell values (using cellForRowAt)")
        cell.textLabel?.text = categoryResults?[indexPath.row].name ?? "No categories added yet"
        //cell.accessoryType = categoryArray[indexPath.row].done ? .checkmark : .none
        
        return cell //renders the cell on screen
    }

    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("Error saving context, \(error)")
        }
        
        print("saved the updated categoryArray")
        
        tableView.reloadData() //refresh tableview from itemsArray
        //cause tableView(.., cellForRowAt ..) to run again
        
    }
    
    func loadCategories() {
        categoryResults = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Add New Catagories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen hen the user clicks the add button on our UIAlert
            print("Success!")
            print(textField.text ?? "default value if textField.text is nil")
            
            let newCategory = Category()
            newCategory.name = textField.text!
            //self.categoryArray.append(newCategory)
            self.save(category: newCategory)
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        //"goToItems" is the identifier of the segue defined in Main.storyboard
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewContr = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow { //current row in table that is selected
            destinationViewContr.selectedCategory = categoryResults?[indexPath.row]
            print("Setting category \(categoryResults?[indexPath.row].name ?? "<none>") in CategoryViewController.")
        }

    }
    
    
}
