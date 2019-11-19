//
//  ShoppingItemTableViewCell.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/31.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit
import Lottie

protocol ShoppingItemCellDelegate {
    func updateItem(item: ShopItemModel, for row:Int)
}

class ShoppingItemTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var checkbox: CheckBox!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var itemTitleCenterYConstraint: NSLayoutConstraint!
    
    private var editingItem = false
    private var editButton: AnimationView?
    private var editButtonFrame : CGRect?
    private var shopItem: ShopItemModel?
    private var row: Int?
    
    var delegate: ShoppingItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCheckBox()
        selectionStyle = .none
        addEditButton()
    }
    
    private func setupCheckBox() {
        checkbox.style = .tick
        checkbox.borderStyle = .rounded
        checkbox.tintColor = .purple
    }
    
    private func addEditButton() {
        let animation = "editOn"
        editButton = AnimationView(name: animation)
        guard let editButton = editButton else {
            return
        }
        editButton.isUserInteractionEnabled = true
        editButton.frame = CGRect(x: contentView.frame.maxX - 30, y: 20, width: 30, height: 30)
        editButton.contentMode = .scaleAspectFill
        editButton.loopMode = .playOnce
        editButton.animationSpeed = 2.0
        addToggleRecognizer(editButton)
        contentView.addSubview(editButton)
    }
    
    private func addToggleRecognizer(_ animationView: AnimationView) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEdit(recognizer:)))
        animationView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func toggleEdit(recognizer: UITapGestureRecognizer) {
        editingItem ? setEditButtonHideEditViewAndSave() : setSaveButtonAndShowEditView()
        }
    
    private func setEditButtonHideEditViewAndSave() {
        // Set edit button
        editingItem = false
        editButton?.play(fromProgress: 0.5, toProgress: 0.0, loopMode: .playOnce)
        editView.setIsHidden(true, animated: true)
        totalPriceLabel.setIsHidden(false, animated: true)
        itemTitleCenterYConstraint.constant = 0
        UIView.animate(withDuration: 0.5) { [weak self] in
          self?.layoutIfNeeded()
        }
        
        // save item
        

        
    }
    private func setSaveButtonAndShowEditView() {
        editingItem = true
        editButton?.play(fromProgress: 0.0, toProgress: 1.0, loopMode: .playOnce)
        editView.setIsHidden(false, animated: true)
        totalPriceLabel.setIsHidden(true, animated: true)
        itemTitleCenterYConstraint.constant = -22
        UIView.animate(withDuration: 0.5) { [weak self] in
          self?.layoutIfNeeded()
        }

    }

    
    func configureFor(item: ShopItemModel, row: Int) {
        shopItem = item
        self.row = row;
        itemTitle?.text = item.title
        cardView.layer.cornerRadius = 20
        editView.layer.cornerRadius = 20
        
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        cardView.layer.shadowOpacity = 0.5

        backgroundColor = UIColor(hexString: "E5B0EA")
    }
    
}
