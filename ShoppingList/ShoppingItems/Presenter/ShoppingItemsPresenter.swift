//
//  ShoppingItemsPresenter.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/30.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation

class ShoppingItemsPresenter: ShoppingItemsPresenterProtocol {
    var view: ShoppingItemsViewProtocol?
    
    var interactor: ShoppingItemsInteractorInputProtocol?
    
    func loadItems() {
        interactor?.getItems()
    }
    
    func deleteItem(_ item: ShopItemModel) {
        interactor?.deleteItem(item.title)
    }
    
    func updateItem(from item: ShopItemModel, to newItem: ShopItemModel) {
        interactor?.updateItem(itemName: item.title, to: mapModel(newItem))
    }
    
    func addItem(_ item: ShopItemModel) {
        interactor?.addItem(mapModel(item))
    }
    
    private func mapModel(_ item: ShopItemModel) -> Item {
        let newItem = Item()
        newItem.title = item.title
        newItem.dateCreated = item.dateCreated
        newItem.done = item.done
        newItem.order = item.order
        
        
        // check quantity
        if let quantity = Int(item.quantity) {
            newItem.quantity = quantity
        } else {
            print("Cannot convert quantity string to integer")
            view?.showError("Quantity must be a number")
        }
        
        // check price
        if let price = Double(item.price) {
            newItem.price = price
        } else {
            print("Cannot convert price string to integer")
            view?.showError("Price must be a number")
        }
        
        
        
        return newItem
    }
    
    private func mapItem(_ item: Item) -> ShopItemModel {
        let newItem = ShopItemModel()
        newItem.title = item.title
        newItem.dateCreated = item.dateCreated
        newItem.done = item.done
        newItem.order = item.order
        
        newItem.price = String(item.price)
        newItem.quantity = String(item.quantity)
        
        return newItem
    }
    
    
}

extension ShoppingItemsPresenter: ShoppingItemsInteractorOutputProtocol {
    func updateSelectedShopTotal(total: Double) {
        view?.updateSelectedShopTotal(total: total)
    }
    
    func didGetItems(_ items: [Item]) {
        let models =  items.map { item -> ShopItemModel in
            return mapItem(item)
        }
        view?.showItems(models)
    }
    
    func onError(_ message: String) {
        view?.showError(message)
    }
    
    
}
