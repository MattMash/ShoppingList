//
//  Data.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/06/01.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var price = 0.0
    @objc dynamic var quantity = 0
    @objc dynamic var order = 0
    var parentCategory = LinkingObjects(fromType: Shop.self, property: "items")
}
