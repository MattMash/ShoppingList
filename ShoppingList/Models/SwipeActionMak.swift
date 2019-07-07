//
//  TableViewTag.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/07/06.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation

enum SwipeActionMask {
    static let none: Int = 0
    static let delete: Int = 0x1
    static let edit: Int = 0x1 << 1
    static let changeColour: Int = 0x1 << 2
}
