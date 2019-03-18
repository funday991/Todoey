//
//  ViewController.swift
//  Todoey
//
//  Created by Yury on 17/03/2019.
//  Copyright © 2019 Yury Buslovsky. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    /************************************************************************************************************************************/
    // MARK: - Properties
    /************************************************************************************************************************************/
    
    var itemArray = [ToDoItem]()
    
    let defaults = UserDefaults.standard
    
    /************************************************************************************************************************************/
    // MARK: - Lifecycle
    /************************************************************************************************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [ToDoItem] {
            itemArray = items
        }
    }
    
    
    /************************************************************************************************************************************/
    // MARK: - TableView Datasource Methods
    /************************************************************************************************************************************/

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let currentItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = currentItem.title
        
        cell.accessoryType = currentItem.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    /************************************************************************************************************************************/
    // MARK: - TableView Delegate Methods
    /************************************************************************************************************************************/

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /************************************************************************************************************************************/
    // MARK: - Add New Items
    /************************************************************************************************************************************/
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            guard textField.text! != "" else { return }
            
            self.itemArray.append(ToDoItem(title: textField.text!))
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
