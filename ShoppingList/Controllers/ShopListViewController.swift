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
    
        loadCategories()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
        
    }
    
    @IBAction func addbuttonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Shop", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let category = Shop()
            
            category.name = textField.text!
            category.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: category)
            
        }
        
        alert.addAction(action)
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
            destinationVC.selectedCategory = shops?[indexPath.row]
        }
        
    }

    
    //MARK: - Data Manipulation Methods
    
    func loadCategories() {
        
        shops = realm.objects(Shop.self)
    
        tableView.reloadData()
    }
    
    func save(category: Shop) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories context")
            print(error)
        }
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.shops?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting categories context")
                print(error)
            }
        }
    }
    
}
