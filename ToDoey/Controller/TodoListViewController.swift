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

    
   var itemArray = [Items]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Items()
        newItem.title = "Minish"
        itemArray.append(newItem)

        let newItem1 = Items()
        newItem1.title = "Umesh"
        itemArray.append(newItem1)
        
        let newItem2 = Items()
        newItem2.title = "Nikhil"
        itemArray.append(newItem2)
        
        
       if let items = defaults.array(forKey: "todoListAttay") as? [Items] {
            self.itemArray = items
        }
        
    }

    //MARK - Methods for Display Rows of Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //useing terenary operator
        cell.accessoryType = item.done == true ? .checkmark : .none
        
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
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
         tableView.reloadData()
    
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
            let newItem = Items()
                newItem.title = textField.text!
            self.itemArray.append(newItem)
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

