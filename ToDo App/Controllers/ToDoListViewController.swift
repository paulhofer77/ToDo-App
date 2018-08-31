//
//  ViewController.swift
//  ToDo App
//
//  Created by Paul Hofer on 25.08.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    
    @IBOutlet weak var searchbar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
//    the navigation bar loads later then "viewDidLoad" function
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        guard let colourHex = selectedCategory?.setColor else { fatalError() }
        uppdateNAvBar(withHExCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       uppdateNAvBar(withHExCode: "1D9BF6")
        
    }
    // MARK: - NavBAr Setuo Methods
    
    func uppdateNAvBar(withHExCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("NavBar not existing")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError("NavBar not existing")}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchbar.barTintColor = navBarColor
    }
    
    
    // MARK: - Table View Data Source Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.setColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
            
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no Items added"
        }

        
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                  item.done = !item.done
                }
            } catch {
                print("error updating data: \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField:UITextField = UITextField()
        let alert = UIAlertController(title: "Add New To Do", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
       //            what happens when the user clicks the add Button
            
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        }
                    }catch {
                     print("Couldn´t Save Category: \(error)")
                        }
                
                }

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

   
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    //Mark: - Delete Data from Swip
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemDelete = self.todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemDelete)
                }
            }catch {
                print("Error while deleting \(error)")
            }

        }
        
    }
    
    
}

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

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





