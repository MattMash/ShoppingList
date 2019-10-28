//
//  ShopViewCell.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/03.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit

class ShopViewCell: UICollectionViewCell {

    
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var firstWhiteView: UIView!
    @IBOutlet weak var lastWhiteView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configureCell(shop: ShopModel) {
        shopNameLabel.text = shop.name
        totalCostLabel.text = "R\(shop.totalCost)"
        shopImageView.image = shop.image?.scaledWidth(to: 60)
        
        // image look
        shopImageView.layer.cornerRadius = 15
        shopImageView.layer.shadowColor = UIColor.black.cgColor
        shopImageView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        shopImageView.layer.shadowOpacity = 0.5
        
        // cell look
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        layer.shadowOpacity = 0.2
        firstWhiteView.layer.cornerRadius = 10
        lastWhiteView.layer.cornerRadius = 10
    }

}
