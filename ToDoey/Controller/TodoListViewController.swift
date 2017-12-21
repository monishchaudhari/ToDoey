//
//  ViewController.swift
//  ToDoey
//
//  Created by Monish Chaudhari on 18/12/17.
//  Copyright © 2017 Monish Chaudhari. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
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
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        updateNoOfItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.title = selectedCategory?.name ?? "Items"
        
        guard let hexColour = selectedCategory!.cellColor else{fatalError()}
            
        updateNavBar(withHexCode: hexColour)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        updateNavBar(withHexCode: "409EFF")
        
    }
    
    //MARK: - Update Navigation bar
    
    func updateNavBar(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller not Loaded")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else{fatalError("")}
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
    }
    
    
    //MARK - Methods for Display Rows of Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //            if let color = UIColor(hexString: selectedCategory!.cellColor!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
            //
            //                cell.backgroundColor = color
            //
            //                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            //            }
            
            cell.accessoryType = item.done == true ? .checkmark : .none //set cell checkmark useing terenary operator
        } //retrive object value for [0/1/2...]
        else {
            cell.textLabel?.text = "No Item Present"
        }
        
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
    
    //MARK: - Delete Row by swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                
            }
        }
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
