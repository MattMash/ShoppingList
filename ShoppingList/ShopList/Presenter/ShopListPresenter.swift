//
//  ShopListPresenter.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/09.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation

class ShopListPresenter: ShopListPresenterProtocol {
    var view: ShopListViewProtocol?
    var router: ShopListRouterProtocol?
    var interactor: ShopListInteractorInputProtocol?
    
    func getShops() {
        interactor?.getShops()
    }
    
    func addShop(_ shop: ShopModel) {
        interactor?.addShop(shop)
    }
    
    func showShopItems(for shop: ShopModel) {
        guard let view = view else { return }
        router?.gotoShopItems(from: view, for: shop)
    }
    
    func deleteShop(_ shop: ShopModel) {
        interactor?.deleteShop(shop)
    }
    
    func updateShop(from oldShop: ShopModel, to newShop: ShopModel) {
        interactor?.updateShop(from: oldShop, to: newShop)
    }
}

extension ShopListPresenter: ShopListInteractorOutputProtocol {
    func didGetShops(_ shops: [ShopModel]) {
        view?.showShops(shops)
    }
    
    func onError(message: String) {
        view?.showError(message: message)
    }
}
