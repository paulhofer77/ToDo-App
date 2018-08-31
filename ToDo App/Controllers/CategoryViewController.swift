//
//  CategoryViewController.swift
//  ToDo App
//
//  Created by Paul Hofer on 26.08.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
       
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Add your first Category"
        
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
    
    
    //Mark: - Add New Categories
    
    @IBAction func addButtonPresses(_ sender: UIBarButtonItem) {
    
        var textfield: UITextField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "Add your new Category", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textfield.text!
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destiantionVC = segue.destination as! ToDoListViewController
        
        if  let indexPath = tableView.indexPathForSelectedRow {
            destiantionVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
