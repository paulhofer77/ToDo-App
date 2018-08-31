//
//  Category.swift
//  ToDo App
//
//  Created by Paul Hofer on 27.08.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
