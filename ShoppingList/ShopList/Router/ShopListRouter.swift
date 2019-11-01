//
//  ShopListRouter.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/10.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import UIKit

class ShopListRouter: ShopListRouterProtocol {
    
    func gotoShopItems(from view: ShopListViewProtocol, for shop: ShopModel) {
        let shoppingItemsViewController = ShoppingItemsRouter.createShoppingItemsModule(for: shop)
             if let sourceView = view as? UIViewController {
                sourceView.navigationController?.pushViewController(shoppingItemsViewController, animated: true)
             }
    }
    
    static func createShopListModule() -> UIViewController {
        let navController = mainStoryboard.instantiateViewController(withIdentifier: "ShopsNavController")
        if let view = navController.children.first as? ShopsViewController {
            let presenter: ShopListPresenterProtocol & ShopListInteractorOutputProtocol = ShopListPresenter()
            let interactor: ShopListInteractorInputProtocol & ShopListDataManagerOutputProtocol = ShopListInteractor()
            let dataManager: ShopListDataManagerInputProtocol = ShopListLocalDataManager()
            let router: ShopListRouterProtocol = ShopListRouter()
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            interactor.presenter = presenter
            interactor.localDataManager = dataManager
            dataManager.interactor = interactor
            
            return navController
        }
        
        return UIViewController()
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }

}
