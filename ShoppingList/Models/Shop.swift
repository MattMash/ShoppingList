//
//  Category.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/06/01.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import RealmSwift

class Shop: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    @objc dynamic var totaltPrice = 0.0
    let items = List<Item>()
    
}
