//
//  ViewController.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/05/30.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ShoppingItemViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var items: Results<Item>?
    let realm = try! Realm()
    
    var selectedShop: Shop? {
        didSet {
            loadItems()
        }
    }
    
    var numberOfItems = 0 // Could be dangerous, consider making a query to re-evaluate each time and update is made
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeActions = SwipeActionMask.delete
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
//        tableView.isEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar =  navigationController?.navigationBar else {
            fatalError()
        }
        
        if let colourHex = selectedShop?.colour {
            title = selectedShop!.name
            if let navBarColour = UIColor(hexString: colourHex){
                navBar.barTintColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                searchBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                searchBar.barTintColor = navBarColour
                searchBar.backgroundColor = navBarColour
                searchBar.delegate = self
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColour = UIColor(hexString: "1D9BF6") else {
            fatalError()
        }
        navigationController?.navigationBar.barTintColor = originalColour
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! realm.write {
            guard let sourceObject = items?[sourceIndexPath.row] else { return }
            guard let destinationObject = items?[destinationIndexPath.row] else { return }
            
            let destinationObjectOrder = destinationObject.order
            
            if sourceIndexPath.row < destinationIndexPath.row {
                for index in sourceIndexPath.row...destinationIndexPath.row {
                    let object = items?[index]
                    object?.order += 1
                }
            } else {
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                    guard let object = items?[index] else { continue }
                    object.order -= 1
                }
            }
            sourceObject.order = destinationObjectOrder
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let colour = UIColor(hexString: selectedShop!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(max(10,items!.count))) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        do {
            if let item = items?[indexPath.row] {
                try realm.write {
                    item.done = !item.done
                }
            }
        } catch {
            print("Error saving item \(error)")
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedShop {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        newItem.done = false
                        newItem.order = self.numberOfItems
                        currentCategory.items.append(newItem)
                    }
                    self.numberOfItems += 1
                } catch {
                    print("Error saving categories context")
                    print(error)
                }
            }
            
            self.tableView.reloadData()
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
    
    func loadItems() {
        items = selectedShop?.items.sorted(byKeyPath: "title", ascending: true).sorted(byKeyPath: "order", ascending: false)
        numberOfItems = items?.count ?? 0
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.items?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
                
                self.numberOfItems -= 1
            } catch {
                print("Error deleting categories context")
                print(error)
            }
        }
    }
}


// Mark: - Searchbar methods

extension ShoppingItemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Get all items first
        loadItems()
        
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!)//.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadItems()
        if searchBar.text?.count == 0 {
            // Dont know if I want to do this
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            items = items?.filter("title CONTAINS[cd] %@", searchBar.text!)//.sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    
    
}

