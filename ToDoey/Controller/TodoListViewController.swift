//
//  ViewController.swift
//  ToDoey
//
//  Created by Monish Chaudhari on 18/12/17.
//  Copyright © 2017 Monish Chaudhari. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Items]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath!)
        
        loadData()
        
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
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add Items to List
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user click add item
            
            if textField.text != "" {
                let newItem = Items()
                newItem.title = textField.text!
                
                self.itemArray.append(newItem)
                self.saveData()
                
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Problem in encoder. \(error )")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try  decoder.decode([Items].self, from: data)
            } catch {
                print("Error in Decoder: \(error)")
            }
            
        }
        
    }
    
}

