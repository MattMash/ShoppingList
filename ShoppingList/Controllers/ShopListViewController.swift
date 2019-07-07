//
//  CategoryViewController.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/06/01.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ShopListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var shops: Results<Shop>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeActions = SwipeActionMask.changeColour | SwipeActionMask.delete
    
        loadShops()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    
    @IBAction func addbuttonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Shop", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let shop = Shop()
            
            shop.name = textField.text!
            shop.colour = UIColor.init(randomFlatColorOf: .light).hexValue()
            
            self.save(shop: shop)
            
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
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = shops?[indexPath.row].name ?? "No Shops Added Yet"
        cell.backgroundColor = UIColor(hexString: shops?[indexPath.row].colour ?? "0096FF")
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as!  ShoppingItemViewController
      
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedShop = shops?[indexPath.row]
        }
        
    }

    
    //MARK: - Data Manipulation Methods
    
    func loadShops() {
        
        shops = realm.objects(Shop.self)
    
        tableView.reloadData()
    }
    
    func save(shop: Shop) {
        
        do {
            try realm.write {
                realm.add(shop)
            }
        } catch {
            print("Error saving shops context")
            print(error)
        }
        
        tableView.reloadData()
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        if let shopForDeletion = self.shops?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(shopForDeletion)
                }
            } catch {
                print("Error deleting shop context")
                print(error)
            }
        }
    }
    
    override func updateModelColour(at indexPath: IndexPath) {
        if let shopforUpdate = self.shops?[indexPath.row] {
            do {
                try self.realm.write {
                    shopforUpdate.colour = UIColor.init(randomFlatColorOf: .light).hexValue()
                }
            }  catch {
                print("Error deleting shop context")
                print(error)
            }
            
            tableView.reloadData()
        }
    }
    
}
