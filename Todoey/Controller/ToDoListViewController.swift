//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Yury on 17/03/2019.
//  Copyright © 2019 Yury Buslovsky. All rights reserved.
//

import UIKit
import RealmSwift


class ToDoListViewController: UITableViewController {

    /************************************************************************************************************************************/
    // MARK: - IBOutlets
    /************************************************************************************************************************************/
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    /************************************************************************************************************************************/
    // MARK: - Properties
    /**************************************************a**********************************************************************************/
    
    let realm = try! Realm()
    
    var toDoItems: Results<ToDoItem>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
//        .appendingPathComponent("ToDoItems.plist")
    
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


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
        
        if let currentItem = toDoItems?[indexPath.row] {
            cell.textLabel?.text = currentItem.title
            
            cell.accessoryType = currentItem.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    /************************************************************************************************************************************/
    // MARK: - TableView Delegate Methods
    /************************************************************************************************************************************/

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        toDoItems[indexPath.row].setValue(!toDoItems[indexPath.row].done, forKey: "done")

//        context.delete(toDoItems[indexPath.row])
//        toDoItems.remove(at: indexPath.row)
//        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
//
//        saveItems()
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    
                    // realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = ToDoItem()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                        
                        // self.realm.add(newItem)
                    }
                } catch {
                    print("Error saving items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
//            let newItem = ToDoItem(context: self.context)
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory

            
//            self.toDoItems.append(newItem)
            
//            self.saveItems()
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
    
//    func saveItems() {
//        let encoder = PropertyListEncoder()
//
//        do {
////            let data = try encoder.encode(toDoItems)
////            try data.write(to: dataFilePath!)
//
//            try context.save()
//        } catch {
//            print("Error saving context, \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
//    func loadItems(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), _ predicate: NSPredicate? = nil) {
////        guard let data = try? Data(contentsOf: dataFilePath!) else { return }
////
////        let decoder = PropertyListDecoder()
////
////        do {
////            itemArray = try decoder.decode([ToDoItem].self, from: data)
////        } catch {
////            print("Error decoding item array, \(error)")
////        }
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//
//            tableView.reloadData()
//        } catch {
//            print("Error fetching data from context, \(error)")
//        }
//    }
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
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
//        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
//
//        if searchBar.text?.count != 0 {
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            loadItems(with: request, NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!))
//        } else {
//            loadItems(with: request)
//        }

    }
    
}

