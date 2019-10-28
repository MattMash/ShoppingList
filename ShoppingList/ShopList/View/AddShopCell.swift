//
//  CollectionViewCell.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/10.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit

class AddShopCell: UICollectionViewCell {
    @IBOutlet weak var addImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addImageView.image = UIImage(named: "add")?.scaledWidth(to: 50)
        addImageView.layer.cornerRadius = 30
    }

}
