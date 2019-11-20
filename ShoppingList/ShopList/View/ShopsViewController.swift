//
//  ShopsViewController.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/04.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit

class ShopsViewController: UIViewController, ShopListViewProtocol {
    var presenter: ShopListPresenterProtocol?
    @IBOutlet weak var shopsCollectionView: UICollectionView!
    @IBOutlet weak var totalCost: UILabel!
    
    private let shopReuseIdentifier = "ShopViewCell"
    private let addReuseIdentifier = "AddShopCell"
    private let itemsPerRow: CGFloat = 2
    private var widthPerItem:  CGFloat = 0
    
    private var shopList: [ShopModel] = []
    
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 10.0,
                                             bottom: 20.0,
                                             right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopsCollectionView.register(UINib.init(nibName: "ShopViewCell", bundle: nil), forCellWithReuseIdentifier: shopReuseIdentifier)
        shopsCollectionView.register(UINib.init(nibName: "AddShopCell", bundle: nil), forCellWithReuseIdentifier: addReuseIdentifier)
     
        shopsCollectionView.dataSource = self
        shopsCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.getShops()
    }
    
    // MARK: - Shop List View Protocol
    
    func showShops(_ shops: [ShopModel]) {
        shopList = shops
        updateTotalLabel()
        shopsCollectionView.reloadData()
    }
    
    func showError(message: String) {
        // TODO: Error view
    }
    
    func showLoading() {
        // TODO: Loading animation
    }
    
    func hideLoading() {
        //TODO:
    }
    
    func showNoShopsView() {
        //TODO:
    }
    
    private func updateTotalLabel() {
        var total = 0.0
        shopList.forEach{shop in
            total = total + shop.totalCost
        }
        totalCost.text = "R" + String(total)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Collection View Delegate

extension ShopsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == shopList.count) {
            addShopTapped()
        } else {
            shopTapped(shop: shopList[indexPath.row])
        }
    }
    
    func addShopTapped() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Shop", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let shop = ShopModel()
            shop.name = textField.text!
            self.presenter?.addShop(shop)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Shop name"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func shopTapped(shop: ShopModel) {
        presenter?.showShopItems(for: shop)
    }
}

// MARK: - Collection View Data Source

extension ShopsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  shopList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == shopList.count) {
            return collectionView.dequeueReusableCell(withReuseIdentifier: addReuseIdentifier, for: indexPath) as! AddShopCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: shopReuseIdentifier, for: indexPath) as! ShopViewCell
        cell.configureCell(shop: shopList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                  ofKind: kind,
                  withReuseIdentifier: "\(CollectionHeaderView.self)",
                  for: indexPath) as? CollectionHeaderView
                else {
                  fatalError("Invalid view type")
              }
            headerView.sectionHeaderLabel.text = "Shopping"
              return headerView
            default:
              assert(false, "Invalid element type")
        }
    }
}

// MARK: - Collection View Flow Layout
extension ShopsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 80)
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
