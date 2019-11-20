//
//  ShopListInteractor.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/09.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import UIKit

class ShopListInteractor: ShopListInteractorInputProtocol {
    
    var localDataManager: ShopListDataManagerInputProtocol?
    var presenter: ShopListInteractorOutputProtocol?
    
    func getShops() {
        localDataManager?.getShops()
    }
    
    func addShop(_ shop: Shop) {
        localDataManager?.addShop(shop)
    }
    
    func deleteShop(_ shop: Shop) {
        localDataManager?.deleteShop(shop)
    }
    
    func updateShop(from oldShopName: String, to newShop: Shop) {
        if let oldShop = localDataManager?.getShopSync(shopName: oldShopName) {
            localDataManager?.updateShop(from: oldShop, to: newShop)
        } else {
            presenter?.onError(message: "Could not find shop to update")
        }
    }
    

    

}

extension ShopListInteractor: ShopListDataManagerOutputProtocol {
    func didGetShops(_ shops: [Shop]) {
        presenter?.didGetShops(shops)
    }
    
    func onSuccessfulShopListUpdate() {
        localDataManager?.getShops()
    }
    
    func onError(_ message: String) {
        presenter?.onError(message: message)
    }
}
