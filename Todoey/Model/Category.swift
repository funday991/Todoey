
//
//  Category.swift
//  Todoey
//
//  Created by Yury on 19/03/2019.
//  Copyright © 2019 Yury Buslovsky. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    
    @objc dynamic var name: String = ""
    
    let items = List<ToDoItem>()
    
}
