//
//  Category.swift
//  ToDoey
//
//  Created by Monish Chaudhari on 20/12/17.
//  Copyright © 2017 Monish Chaudhari. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name : String = ""
    @objc dynamic var dateCreated : Date?
    @objc dynamic var cellColor : String?
    
    let items = List<Item>()
}
