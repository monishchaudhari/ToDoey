//
//  ViewController.swift
//  ToDoey
//
//  Created by Monish Chaudhari on 18/12/17.
//  Copyright © 2017 Monish Chaudhari. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    //connection with contecxt in app delegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print("--------------------Into TodoList")
        // loadData() //calling method
        
    }
    
    //MARK - Methods for Display Rows of Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)  //TOdoItemCell is identifier for cutom cell group
        
        let item = itemArray[indexPath.row] //retrive object value for [0/1/2...]
        
        cell.textLabel?.text = item.title //set lable text of cell
        
        //useing terenary operator
        cell.accessoryType = item.done == true ? .checkmark : .none //set cell checkmark
        
        
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
        
        //set the checkmark value of object
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData() //method call
        
        tableView.deselectRow(at: indexPath, animated: true) //to deselct as soon as we move our finget from row
    }
    
    
    //MARK - Add Items to List
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert) //generate alert box
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen when user click add item
            if textField.text != "" {
                
                let newItem = Item(context: self.context) //object of Item using context
                
                //setting values of properties
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem) //appending to array
                self.saveData() //method call
            }
        }
        
        //alert which takes input from text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil) //perform action 
    }
    
    //function which act like commit operation to the database
    func saveData() {
        do {
            try context.save() //Save the data to database
        } catch {
            print("Errors: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    //create fetch request function with type safety <Item> with default value
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request) //Fetch Data from Database
        } catch {
            print("Error in fetching data: \(error)")
        }
        tableView.reloadData()
        
    }
    
}

//MARK: - Extension by SearchBarDelegate

extension TodoListViewController : UISearchBarDelegate {
    
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //        let request : NSFetchRequest<Item> = Item.fetchRequest()
    //        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    //        loadData(with: request)
    //        }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadData(with: request, predicate: predicate)
            
        }
        
        
        
    }
    
    
}
