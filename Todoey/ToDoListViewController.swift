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
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    
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
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    /************************************************************************************************************************************/
    // MARK: - TableView Delegate Methods
    /************************************************************************************************************************************/

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType
        
        tableView.cellForRow(at: indexPath)?.accessoryType = accessoryType == .checkmark ? .none : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

