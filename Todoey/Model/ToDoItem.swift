//
//  ToDoItem.swift
//  Todoey
//
//  Created by Yury on 18/03/2019.
//  Copyright © 2019 Yury Buslovsky. All rights reserved.
//

import Foundation


class ToDoItem: Codable {
    
    var title: String
    var done = false
    
    init(title: String) {
        self.title = title
    }
    
}
