//
//  ShoppingItemsViewController.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/28.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit

class ShoppingItemsViewController: UITableViewController, ShoppingItemsViewProtocol {
    var presenter: ShoppingItemsPresenterProtocol?
    
    private var items: [ShopItemModel]?
    
    var selectedShop: ShopModel? {
            didSet {
                // interactor must have selected shop set as well
                presenter?.loadItems()
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ShoppingItemTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        title = selectedShop!.name

    }
    
    @objc
    private func addTapped() {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = ShopItemModel()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            newItem.done = false
            newItem.order = (self.items?.count ?? 0) + 1
            self.presenter?.addItem(newItem)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                  alert.dismiss(animated: true)
              }

              alert.addAction(action)
              alert.addAction(cancelAction)
              alert.addTextField { (alertTextfield) in
                  alertTextfield.placeholder = "Item name"
                  textField = alertTextfield
              }

              present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ShoppingItems View Protocol
    
    func showItems(_ items: [ShopItemModel]) {
        self.items = items
        tableView.reloadData()
    }
    
    func showLoading() {
        
    }
    
    func showError(_ message: String) {
        
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShoppingItemTableViewCell
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
}
