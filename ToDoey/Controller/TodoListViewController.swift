//
//  ViewController.swift
//  ToDoey
//
//  Created by Monish Chaudhari on 18/12/17.
//  Copyright © 2017 Monish Chaudhari. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var noOfItems: UIBarButtonItem!
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        navigationItem.title = selectedCategory?.name ?? "Items"
        updateNoOfItems()
        
    }
    
    //MARK - Methods for Display Rows of Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)  //TOdoItemCell is identifier for cutom cell group
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title //set lable text of cell
            
            cell.accessoryType = item.done == true ? .checkmark : .none //set cell checkmark useing terenary operator
            
        } //retrive object value for [0/1/2...]
        else {
            cell.textLabel?.text = "No Item Present"
        }
        
        //This comented code work same like upper line
        /* ^ use terenary instead
         if item.done == true {
         cell.accessoryType = .checkmark
         } else {
         cell.accessoryType = .none
         }*/
        return cell
    }
    
    
    //MARK - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error during update done status: \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            if let item = todoItems?[indexPath.row] {
                
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                } catch {
                    
                }
            }
            tableView.reloadData()
            updateNoOfItems()
        }
    }
    
    //MARK - Add Items to List
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert) //generate alert box
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen when user click add item
            if textField.text != "" {
                
                if let curruntCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            curruntCategory.items.append(newItem)
                        }
                    } catch {
                        print("Errors in Saving to Item: \(error)")
                    }
                }
            }
            self.tableView.reloadData()
            self.updateNoOfItems()
        }
        
        //alert which takes input from text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil) //perform action
    }
    
    
    //create fetch request function with type safety <Item> with default value
    func loadData() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        updateNoOfItems()
    }
    
    func updateNoOfItems() {
        let numberofItemsOnPage : Int = todoItems?.count ?? 0
        if numberofItemsOnPage == 0 {
            noOfItems.title = "Add Items "
        }
        else {
            noOfItems.title = "\(todoItems?.count ?? 0) "
        }
    }
}

//MARK: - Extension by SearchBarDelegate

extension TodoListViewController : UISearchBarDelegate {
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
            if searchBar.text?.count == 0 {
                loadData()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
    
            } else {
    
                todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
                tableView.reloadData()
            }
  
        }

}
