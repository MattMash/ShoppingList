//
//  ShoppingItemsRouter.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/28.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import UIKit

class ShoppingItemsRouter: ShoppingItemsRouterProtocol {
    static func createShoppingItemsModule(for shop: ShopModel) -> UIViewController {
        let shoppingItemsVC = mainStoryboard.instantiateViewController(withIdentifier: "ShoppingItemsController") as! ShoppingItemsViewProtocol
        
        let presenter = ShoppingItemsPresenter()
        let interactor = ShoppingItemsInteractor()
        let shopDataSource = ShopListLocalDataManager()
        let itemDataSource = ShoppingItemsDataManager()
        
        shoppingItemsVC.presenter = presenter
        presenter.interactor = interactor
        presenter.view = shoppingItemsVC
        interactor.itemDataManager = itemDataSource
        interactor.shopDataManager = shopDataSource
        interactor.setSelectedShop(shopName: shop.name)
        interactor.presenter = presenter
        itemDataSource.interactor = interactor
        shoppingItemsVC.selectedShop = shop
        
        return shoppingItemsVC as! UIViewController
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
