//
//  ToDoItem.swift
//  Todoey
//
//  Created by Yury on 19/03/2019.
//  Copyright © 2019 Yury Buslovsky. All rights reserved.
//

import Foundation
import RealmSwift


class ToDoItem: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
