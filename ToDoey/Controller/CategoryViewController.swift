//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Monish Chaudhari on 19/12/17.
//  Copyright © 2017 Monish Chaudhari. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadData()
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != "" {
                let newCategory = Category(context: self.context)
                
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                self.saveData()
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
        print("--------------------------Segue Performed")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        print("--------------------------Segue altered")
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error in Save Data : \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest() ) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error in load Data: \(error)")
        }
        
        tableView.reloadData()
    }
}
