//
//  ShopListLocalDataManager.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/09.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import RealmSwift

class ShopListLocalDataManager: ShopListDataManagerInputProtocol {
    let realm = try! Realm()
    var interactor: ShopListDataManagerOutputProtocol?
    
    func deleteShop(_ shop: Shop) {
        do {
            try self.realm.write {
                self.realm.delete(shop)
            }
        } catch {
            print(error)
            interactor?.onError(message: "Error deleting shop context")
        }
    }
    
    func updateShop(from oldShop: Shop, to newShop: Shop) {
        do {
            try self.realm.write {
                oldShop.colour = newShop.colour
                oldShop.name = newShop.name
            }
            interactor?.onSuccessfulUpdate()
        }  catch {
            print(error)
            interactor?.onError(message: "Error updating shop context")
        }
    }
    
    func getShops() {
        let shops = realm.objects(Shop.self)
        let shops2: [Shop] = shops.map{$0}
        interactor?.didGetShops(shops2)
    }
    
    func addShop(_ shop: Shop) {
        do {
            try realm.write {
                realm.add(shop)
            }
            interactor?.onSuccessfulUpdate()
        } catch {
            print("Error saving shops context")
            print(error)
            interactor?.onError(message: "Error saving shops context")
        }
    }
}
