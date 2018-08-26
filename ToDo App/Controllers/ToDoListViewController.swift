//
//  ViewController.swift
//  ToDo App
//
//  Created by Paul Hofer on 25.08.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }

  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
    
        
    }

    // MARK: - Table View Data Source Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        this line is a shorter version of the if-statement below - it is a ternery Operator
//        Ternery Operator: value = condition ? valueTrue : valueFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
/*        the order of these 2 functions mather a lot
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
*/
 
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }

    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField:UITextField = UITextField()
        let alert = UIAlertController(title: "Add New To Do", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
       //            what happens when the user clicks the add Button
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
      
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Item"
            textField = alertTextfield
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Error saving Context \(error)")
        }
    
        tableView.reloadData()
    }
   
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//  diese Funktion hat einen Externen PArameter (with), einen internen Paramter (request) und einen Default Parameter (Item.fetchRequest)
//  let request: NSFetchRequest<Item> = Item.fetchRequest() >> diuese zeile ist nicht notwendig, da sie als Default Paramter bereits oben eingefügt wurde
//  wenn ein predicate in der funktion gegeben wird (siehe searchBar, dann werden 2 Predicates gemeinsam verwendent, wenn aber kein Prdicate in er Funktion mitgegeben wird, wird nur das category predicate verwendet
       
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
       
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }

        
        do {
            itemArray = try context.fetch(request)
        }catch {
            print("Error fetching data \(error)")
        }
   
        tableView.reloadData()
    }
    
    
}

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
    
    
}





