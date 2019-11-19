//
//  ShoppingItemsViewController.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/28.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit

class ShoppingItemsViewController: UIViewController, ShoppingItemsViewProtocol, ShoppingItemCellDelegate {
    var presenter: ShoppingItemsPresenterProtocol?
    private var items: [ShopItemModel]?
    @IBOutlet weak var itemsTableView: UITableView!
    
    var selectedShop: ShopModel?
    
    @IBOutlet weak var shopCardView: UIView!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        shopNameLabel.text = selectedShop?.name
        
        shopImageView.image = selectedShop?.image?.scaledWidth(to: 80.0)
        shopImageView.layer.cornerRadius = 20.0
        
        // interactor must have selected shop set as well
        presenter?.loadItems()
    }
    
    fileprivate func setupTableView() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.separatorStyle = .none
        itemsTableView.rowHeight = 120.0
        itemsTableView.backgroundColor = UIColor(hexString: "E5B0EA")
        itemsTableView.register(UINib(nibName: "ShoppingItemTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
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
        itemsTableView.reloadData()
    }
    
    func showLoading() {
        
    }
    
    func showError(_ message: String) {
        
    }
    
    // MARK: - ShoppingItemCellDelegate
    func updateItem(item: ShopItemModel, for row: Int) {
        guard let oldItem =  items?[row] else { return }
        presenter?.updateItem(from: oldItem, to: item)
    }
    
}
    
// MARK: - TableView Data Source
extension ShoppingItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShoppingItemTableViewCell
        cell.backgroundColor = UIColor(hexString: "E5B0EA")
        cell.delegate = self
        if let item = items?[indexPath.row] {
            cell.configureFor(item: item, row: indexPath.row)
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
}
    
    // MARK: - TableView Delegate
extension ShoppingItemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
