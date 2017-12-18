//
//  ViewController.swift
//  ToDoey
//
//  Created by Monish Chaudhari on 18/12/17.
//  Copyright © 2017 Monish Chaudhari. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
   var itemArray = ["Buy Eggs", "Buy Milk", "Buy Chocolate"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "todoListAttay") as? [String] {
            self.itemArray = items
        }
        
    }

    //MARK - Methods for Display Rows of Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            print("\(itemArray[indexPath.row]) is Unchecked")
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            print("\(itemArray[indexPath.row]) is Checked")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add Items to List
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user click add item
            print("Success!")
            if textField.text != "" {
                
            self.itemArray.append(textField.text!)
                self.defaults.set(self.itemArray, forKey: "todoListAttay")
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

