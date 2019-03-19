//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yury on 19/03/2019.
//  Copyright © 2019 Yury Buslovsky. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    /************************************************************************************************************************************/
    // MARK: - TableView Properties
    /************************************************************************************************************************************/
    
    var categoriesArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /************************************************************************************************************************************/
    // MARK: - Lifecycle
    /************************************************************************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    /************************************************************************************************************************************/
    // MARK: - TableView Datasource Methods
    /************************************************************************************************************************************/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        
        return cell
    }
    
    /************************************************************************************************************************************/
    // MARK: - TableView Delegate Methods
    /************************************************************************************************************************************/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    /************************************************************************************************************************************/
    // MARK: - Data Manipulation Methods
    /************************************************************************************************************************************/
    
    func saveCategories() {
        do {
            try context.save()
            
            tableView.reloadData()
        } catch {
            print("Error saving categories, \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoriesArray = try context.fetch(request)
            
            tableView.reloadData()
        } catch {
            print("Error fetching categories, \(error)")
        }
    }
    
    /************************************************************************************************************************************/
    // MARK: - IBActions
    /************************************************************************************************************************************/
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            guard textField.text! != "" else { return }
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoriesArray.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
