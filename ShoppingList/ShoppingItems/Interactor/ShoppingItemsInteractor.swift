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
        if let itemToDelete = selectedShop?.items.filter("title == %@", itemName).first {
            itemDataManager?.deleteItem(itemToDelete)
        }
    }
    
    func updateItem(itemName: String, to newItem: Item) {
        if let itemToUpdate = selectedShop?.items.filter("title == %@", itemName).first {
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
    func onSuccessfulUpdate() {
        updateShopTotalCost()
        getItems()
    }
    
    func didGetItems(_ items: [Item]) {
        presenter?.didGetItems(items)

    }

    func onError(_ message: String) {
        presenter?.onError(message)
    }

    private func updateShopTotalCost() {
        var totalPrice = 0.0
        selectedShop?.items.forEach { item in
            totalPrice = totalPrice + item.price * Double(item.quantity)
        }

        if let selectedShop = selectedShop {
            let newShop = Shop()
            newShop.name  = selectedShop.name
            newShop.totaltPrice = totalPrice
            shopDataManager?.updateShop(from: selectedShop, to: newShop)
        }
    }
}

extension ShoppingItemsInteractor: ShopListDataManagerOutputProtocol {
    func didGetShops(_ shops: [Shop]) {
        // not used
    }
    
    func onSuccessfulShopListUpdate() {
        selectedShop = shopDataManager?.getShopSync(shopName: selectedShop!.name)
        presenter?.updateSelectedShopTotal(total: selectedShop!.totaltPrice)
    }

}




