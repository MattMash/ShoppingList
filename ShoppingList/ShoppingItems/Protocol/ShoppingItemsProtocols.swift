//
//  ShoppingItemsProtocols.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/28.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import UIKit

protocol ShoppingItemsViewProtocol: class {
    var selectedShop: ShopModel? { get set }
    var presenter: ShoppingItemsPresenterProtocol? { get set }

    func showItems(_ items: [ShopItemModel])
   
    func showLoading()
    
    func showError(_ message: String)
}

protocol ShoppingItemsPresenterProtocol {
    var view: ShoppingItemsViewProtocol? { get set }
    var interactor: ShoppingItemsInteractorInputProtocol? { get set}
    
    func loadItems()
    
    func deleteItem(_ item: ShopItemModel)
    
    func updateItem(from item: ShopItemModel, to newItem: ShopItemModel)
    
    func addItem(_ item: ShopItemModel)
}

protocol ShoppingItemsInteractorInputProtocol {
    var presenter: ShoppingItemsInteractorOutputProtocol? { get set }
    var itemDataManager: ShoppingItemsDataManagerInputProtocol? { get set }
    var shopDataManager: ShopListDataManagerInputProtocol? { get set }
    
    func setSelectedShop(shopName: String)
    
    func getItems()
    
    func deleteItem(_ itemName: String)
    
    func updateItem(itemName: String, to newItem: Item)
    
    func addItem(_ item: Item)
    
}

protocol ShoppingItemsInteractorOutputProtocol {
    
    func didGetItems(_ items: [Item])
    
    func onError(_ message: String)
}

protocol ShoppingItemsDataManagerInputProtocol {
    var interactor: ShoppingItemsDataManagerOutputProtocol? { get set }
    
    func getItems(for shop: Shop)
    
    func deleteItem(_ item: Item)
    
    func updateItem(from item: Item, to newItem: Item)
    
    func addItem(item: Item, for shop: Shop)
}

protocol ShoppingItemsRouterProtocol {
    static func createShoppingItemsModule(for shop: ShopModel) -> UIViewController
}

protocol ShoppingItemsDataManagerOutputProtocol {
    func didGetItems(_ items: [Item])
    
    func onSuccessfulUpdate()
    
    func onError(_ message: String)
}
