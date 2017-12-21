//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Monish Chaudhari on 19/12/17.
//  Copyright © 2017 Monish Chaudhari. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    @IBOutlet weak var noOfItems: UIBarButtonItem!
    
    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        loadData()
        updateNoOfItems()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.tintColor = UIColor(hexString: "409EFF")
//    }
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added"
        
        if let color = UIColor(hexString: categories?[indexPath.row].cellColor ?? "1D9BF6") {
            
        cell.backgroundColor = color
        
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            
        cell.tintColor = ContrastColorOf(color, returnFlat: true)
     
        }
        
        return cell
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.dateCreated = Date()
                newCategory.cellColor = UIColor.randomFlat.hexValue() 
                self.save(category: newCategory)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
           tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error in Save Data : \(error)")
        }
        tableView.reloadData()
        updateNoOfItems()
    }
    
    func loadData() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        updateNoOfItems()
    }
    
    //MARK: - Delete Row by Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryClicked = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryClicked)
                }
            } catch {
                print("Error in delete category: \(error)")
            }
        }
        updateNoOfItems()
    }
    
    func updateNoOfItems() {
        
        let numberofItemsOnPage : Int = categories?.count ?? 0
        if numberofItemsOnPage == 0 {
            noOfItems.title = "Add Category "
        }
        else {
            noOfItems.title = "\(categories?.count ?? 0) "
        }
    }
}


//MARK: - Extension by SearchBarDelegate

extension CategoryViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            
            categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
        
    }
    
}


