//
//  CategoryViewController.swift
//  ToDo App
//
//  Created by Paul Hofer on 26.08.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    
    }

    //Mark: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if let category = categories?[indexPath.row] {
        
            guard let categoryColor = UIColor(hexString: category.setColor) else { fatalError() }
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            cell.textLabel?.text = category.name
            
    }
        return cell
    }
    
    //Mark: - Data Model Manipulation
    func save(category:Category){
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Couldn´t Save Category: \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
        
    }
     //Mark: - Delete Data from Swip
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryDelete = self.categories?[indexPath.row] {
            do {
                try realm.write {
                realm.delete(categoryDelete)
                }
            }catch {
                print("Error while deleting \(error)")
            }
        }
            
    }
    
    
    
    //Mark: - Add New Categories
    
    @IBAction func addButtonPresses(_ sender: UIBarButtonItem) {
    
        var textfield: UITextField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "Add your new Category", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textfield.text!
            
            newCategory.setColor = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create your new Category"
            textfield = alertTextfield
        }
        
        present(alert, animated: true, completion: nil)
    
    }
    
  
    //Mark: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    
    
    
    //Mark: - Segue Setup
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destiantionVC = segue.destination as! ToDoListViewController
        
        if  let indexPath = tableView.indexPathForSelectedRow {
            destiantionVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    
}

