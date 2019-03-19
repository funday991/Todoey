//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Yury on 17/03/2019.
//  Copyright © 2019 Yury Buslovsky. All rights reserved.
//

import UIKit
import CoreData


class ToDoListViewController: UITableViewController {

    /************************************************************************************************************************************/
    // MARK: - IBOutlets
    /************************************************************************************************************************************/
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    /************************************************************************************************************************************/
    // MARK: - Properties
    /**************************************************a**********************************************************************************/
    
    var itemArray = [ToDoItem]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
//        .appendingPathComponent("ToDoItems.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    /************************************************************************************************************************************/
    // MARK: - Lifecycle
    /************************************************************************************************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
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
//        itemArray[indexPath.row].setValue(!itemArray[indexPath.row].done, forKey: "done")

//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()

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
            
            let newItem = ToDoItem(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    /************************************************************************************************************************************/
    // MARK: - Model Manipulation Methods
    /************************************************************************************************************************************/
    
    func saveItems() {
        // let encoder = PropertyListEncoder()
        
        do {
            // let data = try encoder.encode(itemArray)
            // try data.write(to: dataFilePath!)
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), _ predicate: NSPredicate? = nil) {
//        guard let data = try? Data(contentsOf: dataFilePath!) else { return }
//
//        let decoder = PropertyListDecoder()
//
//        do {
//            itemArray = try decoder.decode([ToDoItem].self, from: data)
//        } catch {
//            print("Error decoding item array, \(error)")
//        }
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
            
            tableView.reloadData()
        } catch {
            print("Error fetching data from context, \(error)")
        }
    }
    
}


/************************************************************************************************************************************/
// MARK: - SearchBar Methods
/************************************************************************************************************************************/

extension ToDoListViewController: UISearchBarDelegate {
    
    /************************************************************************************************************************************/
    // MARK: - SearchBar Delegate Methods
    /************************************************************************************************************************************/
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
//        }
        searchBar.resignFirstResponder()
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        if searchBar.text?.count != 0 {
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!))
        } else {
            loadItems(with: request)
        }
        
    }
}

