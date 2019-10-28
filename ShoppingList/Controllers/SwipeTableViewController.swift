//
//  SwipeTableViewController.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/06/03.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var swipeActions: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        guard let swipeActions = swipeActions  else { return nil }
        
        var actions = [SwipeAction]()
        
        if swipeActions & SwipeActionMask.delete == SwipeActionMask.delete {
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                self.deleteModel(at: indexPath)
            }
            deleteAction.image = UIImage(named: "delete")
            actions.append(deleteAction)
        }
        
        if swipeActions & SwipeActionMask.changeColour == SwipeActionMask.changeColour {
            let changeColourAction = SwipeAction(style: .default, title: "Colour") { action, indexPath in
                let cell = self.tableView(self.tableView, cellForRowAt: indexPath) as! SwipeTableViewCell
                self.updateModelColour(at: indexPath)
            }
            changeColourAction.image = UIImage(named: "colour")?.scaledWidth(to: 30.0)
            changeColourAction.backgroundColor = UIColor.flatSkyBlue()
            actions.append(changeColourAction)
        }
        
        return actions.count > 0 ? actions : nil
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteModel(at indexPath: IndexPath) {
        
    }
    
    func updateModelColour(at indexPath: IndexPath) {
        
    }
    
}
