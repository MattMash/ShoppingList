//
//  ShopListProtocols.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/09.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import UIKit

protocol ShopListViewProtocol {
    var presenter: ShopListPresenterProtocol? { get set }
    
    // Presenter -> View
    func showShops(_ shops: [ShopModel])
    
    func showError(message: String)
    
    func showLoading()
    
    func hideLoading()
    
    func showNoShopsView()
}

protocol ShopListPresenterProtocol: class {
    var view: ShopListViewProtocol? { get set }
    var router: ShopListRouterProtocol? { get set }
    var interactor: ShopListInteractorInputProtocol? { get set }
    
    // View -> Presenter
    func getShops()
    
    func addShop(_ shop: ShopModel)
    
    func deleteShop(_ shop: ShopModel)
    
    func updateShop(from oldShopName: String, to newShop: ShopModel)
    
    func showShopItems(for shop: ShopModel)
    
}

protocol ShopListInteractorInputProtocol: class {
    var presenter: ShopListInteractorOutputProtocol? { get set }
    var localDataManager: ShopListDataManagerInputProtocol? { get set }
    
    // Presenter -> Interactor
    func getShops()
    
    func addShop(_ shop: Shop)
    
    func deleteShop(_ shop: Shop)
    
    func updateShop(from oldShopName: String, to newShop: Shop)
}

protocol ShopListInteractorOutputProtocol: class {
    
    // Interactor -> Pressenter
    func didGetShops(_ shops: [Shop])
    
    func onError(message: String)
}

protocol ShopListRouterProtocol {
    static func createShopListModule() -> UIViewController
    
    func gotoShopItems(from view: ShopListViewProtocol, for shop: ShopModel)
    
}

protocol ShopListDataManagerInputProtocol: class {
    var interactor: ShopListDataManagerOutputProtocol? { get set }
    
    func getShops()
    
    func getShopSync(shopName: String) -> Shop?
    
    func addShop(_ shop: Shop)

    func deleteShop(_ shop: Shop)
    
    func updateShop(from oldShop: Shop, to newShop: Shop)
    
}

protocol ShopListDataManagerOutputProtocol {
    func didGetShops(_ shops: [Shop])
    
    func onSuccessfulUpdate()
    
    func onError(_ message: String)
}
