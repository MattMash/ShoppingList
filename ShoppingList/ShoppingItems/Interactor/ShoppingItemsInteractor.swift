//
//  ShoppingItemsIntercator.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/28.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation

class ShoppingItemsInteractor: ShoppingItemsInteractorInputProtocol {
    var presenter: ShoppingItemsInteractorOutputProtocol?
    
    var itemDataManager: ShoppingItemsDataManagerInputProtocol?
    
    var shopDataManager: ShopListDataManagerInputProtocol?
    
    private var selectedShop: Shop?
    
    func setSelectedShop(shopName: String) {
        selectedShop = shopDataManager?.getShopSync(shopName: shopName)
    }
    
    func getItems() {
        if let shop = selectedShop {
            itemDataManager?.getItems(for: shop)
        } else {
            presenter?.onError("Could not find shop")
        }
    }
    
    func deleteItem(_ itemName: String) {
        if let itemToDelete = selectedShop?.items.filter("title == \(itemName)").first {
            itemDataManager?.deleteItem(itemToDelete)
        }
    }
    
    func updateItem(itemName: String, to newItem: Item) {
         if let itemToUpdate = selectedShop?.items.filter("title == \(itemName)").first {
            itemDataManager?.updateItem(from: itemToUpdate, to: newItem)
        }
    }
    
    func addItem(_ item: Item) {
        if let shop = selectedShop {
            itemDataManager?.addItem(item: item, for: shop)
        }
    }
}

extension ShoppingItemsInteractor: ShoppingItemsDataManagerOutputProtocol {
    func didGetItems(_ items: [Item]) {
        presenter?.didGetItems(items)
    }
    
    func onSuccessfulUpdate() {
        getItems()
    }
    
    func onError(_ message: String) {
        presenter?.onError(message)
    }
}




