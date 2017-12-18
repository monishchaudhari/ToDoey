//
//  ViewController.swift
//  ToDoey
//
//  Created by Monish Chaudhari on 18/12/17.
//  Copyright © 2017 Monish Chaudhari. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Buy Eggs", "Buy Milk", "Buy Chocolate"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

    
}

