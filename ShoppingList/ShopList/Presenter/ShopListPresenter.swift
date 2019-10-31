//
//  ShopListPresenter.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/09.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import UIKit

class ShopListPresenter: ShopListPresenterProtocol {
    var view: ShopListViewProtocol?
    var router: ShopListRouterProtocol?
    var interactor: ShopListInteractorInputProtocol?
    
    func getShops() {
        interactor?.getShops()
    }
    
    func addShop(_ shop: ShopModel) {
        interactor?.addShop(mapModel(shop))
    }
    
    func showShopItems(for shop: ShopModel) {
        guard let view = view else { return }
        router?.gotoShopItems(from: view, for: shop)
    }
    
    func deleteShop(_ shop: ShopModel) {
        interactor?.deleteShop(mapModel(shop))
    }
    
    func updateShop(from oldShopName: String, to newShop: ShopModel) {
        interactor?.updateShop(from: oldShopName, to: mapModel(newShop))
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

extension ShopListPresenter: ShopListInteractorOutputProtocol {
    func didGetShops(_ shops: [Shop]) {
        let shopModels = shops.map { shop -> ShopModel in
            return mapShop(shop)
        }
        view?.showShops(shopModels)
    }
    
    func onError(message: String) {
        view?.showError(message: message)
    }
}
