//
//  ShoppingItemsDataManager.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/28.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import RealmSwift

class ShoppingItemsDataManager: ShoppingItemsDataManagerInputProtocol {
    let realm = try! Realm()
    var interactor: ShoppingItemsDataManagerOutputProtocol?
    
    func getItems(for shop: Shop) {
        let items: [Item] = shop.items.sorted(byKeyPath: "order", ascending: false).map{$0}
        interactor?.didGetItems(items)
    }
    
    func deleteItem(_ item: Item) {
        do {
            try self.realm.write {
                self.realm.delete(item)
            }
        } catch {
            print(error)
            interactor?.onError("Error deleting shopping item context")
        }
    }
    
    func updateItem(from item: Item, to newItem: Item) {
        do {
            try self.realm.write {
                item.title = newItem.title
                item.done = newItem.done
                item.order = newItem.order
            }
            interactor?.onSuccessfulUpdate()
        }  catch {
            print(error)
            interactor?.onError("Error updating shopping item context")
        }
    }
    
    func addItem(item: Item, for shop: Shop) {
        do {
            try realm.write {
                shop.items.append(item)
            }
            interactor?.onSuccessfulUpdate()
        } catch {
            print("Error saving shopping item context")
            print(error)
            interactor?.onError("Error saving shopping item context")
        }
    }
    
    
}
