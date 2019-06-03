//
//  Category.swift
//  Todoey
//
//  Created by Matthew Mashiane on 2019/06/01.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
    
}
