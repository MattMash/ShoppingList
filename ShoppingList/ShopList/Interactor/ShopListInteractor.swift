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
    
    func addShop(_ shop: ShopModel) {
        localDataManager?.addShop(mapModel(shop))
    }
    
    func deleteShop(_ shop: ShopModel) {
        localDataManager?.deleteShop(mapModel(shop))
    }
    
    func updateShop(from oldShop: ShopModel, to newShop: ShopModel) {
        localDataManager?.updateShop(from: mapModel(oldShop), to: mapModel(newShop))
    }
    
    private func mapShop(_ shop: Shop) -> ShopModel {
        let shopModel = ShopModel()
        shopModel.name = shop.name
        shopModel.image = getShopImage(shop.name) ?? UIImage(named: "shopping-cart")
        return shopModel
    }
    
    private func mapModel(_ model: ShopModel) -> Shop {
        let shop = Shop()
        shop.name = model.name
        return shop
    }
    
    private func getShopImage(_ shopName: String) -> UIImage? {
        guard let assetName = mapShopNamesToAssetName[shopName.lowercased()] else { return nil }
        return UIImage(named: assetName)
    }
}

extension ShopListInteractor: ShopListDataManagerOutputProtocol {
    func didGetShops(_ shops: [Shop]) {
        let shopModels = shops.map { shop -> ShopModel in
            return mapShop(shop)
        }
        presenter?.didGetShops(shopModels)
    }
    
    func onSuccessfulUpdate() {
        localDataManager?.getShops()
    }
    
    func onError(message: String) {
        presenter?.onError(message: message)
    }
}
