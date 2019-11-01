//
//  ShoppingItemTableViewCell.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/31.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit

class ShoppingItemTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var checkbox: CheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCheckBox()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureFor(item: ShopItemModel) {
        itemTitle?.text = item.title
        cardView.layer.cornerRadius = 20
        
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        cardView.layer.shadowOpacity = 0.5

        backgroundColor = UIColor(hexString: "E5B0EA")
    }
    
    fileprivate func setupCheckBox() {
        // Initialization code
        checkbox.style = .tick
        checkbox.borderStyle = .rounded
        checkbox.tintColor = .purple
        
//        NSLayoutConstraint(item:cardView , attribute: .leading, relatedBy: .equal, toItem: checkbox!, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
//         
//        NSLayoutConstraint(item: cardView, attribute: .top, relatedBy: .equal, toItem: checkbox!, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    }
    
}
