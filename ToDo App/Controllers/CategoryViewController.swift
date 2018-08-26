//
//  CategoryViewController.swift
//  ToDo App
//
//  Created by Paul Hofer on 26.08.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    //Mark: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
       
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //Mark: - Data Model Manipulation
    func saveCategories(){
        do {
            try context.save()
        }catch {
            print("Couldn´t Save Category: \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategories(request: NSFetchRequest<Category> = Category.fetchRequest() ) {
        
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print("Couldn´t Fetch Category: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //Mark: - Add New Categories
    
    @IBAction func addButtonPresses(_ sender: UIBarButtonItem) {
    
        var textfield: UITextField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "Add your new Category", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategories()
            
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
            destiantionVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
