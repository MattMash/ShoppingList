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
    func updateItem(item: ShopItemModel?, for row: Int?)
    func deleteItem(row: Int?)
}

class ShoppingItemTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var checkbox: CheckBox!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var itemTitleCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceTextfield: UITextField!
    @IBOutlet weak var quantityTextfield: UITextField!
    
    private var deleteState = false
    private var maxDeleteWidth: CGFloat = 80.0
    private var editingItem = false
    private var editButton: AnimationView?
    private var editButtonFrame : CGRect?
    private var shopItem: ShopItemModel?
    private var row: Int?
    private var pan: UIPanGestureRecognizer!
    
    
    var delegate: ShoppingItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCheckBox()
        selectionStyle = .none
        addEditButton()
        
        // swipe
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
        setupDeleteView()
    
    }
    
    private func setupCheckBox() {
        checkbox.style = .tick
        checkbox.borderStyle = .rounded
        checkbox.tintColor = .purple
    }
    
    private func setupDeleteView() {
        let deleteImageView = UIImageView(image: UIImage(named: "delete")?.scaledWidth(to: 30))
        deleteImageView.contentMode = .center
    
        deleteImageView.clipsToBounds = true
        deleteView.clipsToBounds = true
        addDeleteTapRecognizer(deleteView)
        
        deleteView.addSubview(deleteImageView)

        let _ = deleteImageView.pinEdgesToSuperview()
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addDeleteTapRecognizer(_ deleteView: UIView) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteTapped(recognizer:)))
        deleteView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func deleteTapped(recognizer: UITapGestureRecognizer) {
        deleteViewWidthConstraint.constant = 0
        deleteState = false
        editButton?.alpha = 1
        self.delegate?.deleteItem(row: self.row)
    }
    
    private func addEditButton() {
        let animation = "editOn"
        editButton = AnimationView(name: animation)
        guard let editButton = editButton else {
            return
        }
        editButton.isUserInteractionEnabled = true
        editButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        editButton.contentMode = .scaleAspectFill
        editButton.loopMode = .playOnce
        editButton.animationSpeed = 2.0
        addToggleRecognizer(editButton)
        contentView.addSubview(editButton)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8).isActive = true
        editButton.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -10).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.layoutIfNeeded()
        }){ _ in
            // save item
            self.shopItem?.quantity = self.quantityTextfield.text ?? "0"
            self.shopItem?.price = self.priceTextfield.text ?? "0"
            self.delegate?.updateItem(item: self.shopItem, for: self.row)
        }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func setDeleteViewWidth() {
//        if (pan.state == UIGestureRecognizer.State.changed) {
            let p: CGPoint = pan.translation(in: self)

            // not delete state
            if (!deleteState) {
                // if not in deleted state, only accept left swipe
                guard p.x < 0 else { return }
                
                // set delete view width
                if (deleteViewWidthConstraint.constant < maxDeleteWidth) {
                    deleteViewWidthConstraint.constant = -p.x
                    editButton?.alpha = max(1 + 0.02*(p.x), 0)
                }
                if (deleteViewWidthConstraint.constant > maxDeleteWidth) {
                    deleteViewWidthConstraint.constant = maxDeleteWidth
                }
                
            // delete state
            } else {
                guard p.x > 0 else { return }
                if (deleteViewWidthConstraint.constant >= 0) {
                    deleteViewWidthConstraint.constant = maxDeleteWidth - p.x
                    editButton?.alpha = min(0.01*(p.x), 1)
                } else if (deleteViewWidthConstraint.constant < 0) {
                    deleteViewWidthConstraint.constant = 0
                }
                
            }
            
//        }
    }
    
    @objc
    func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {
        } else if pan.state == UIGestureRecognizer.State.changed {
            setDeleteViewWidth()
            self.setNeedsLayout()
        } else {
//            if abs(pan.velocity(in: self).x) > 500 {
                //                   let collectionView: UICollectionView = self.superview as! UICollectionView
                //                   let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                //                   collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
//            } else {
                if (deleteViewWidthConstraint.constant >= maxDeleteWidth) {
                    deleteState = true
                    deleteViewWidthConstraint.constant = maxDeleteWidth
                } else if (deleteViewWidthConstraint.constant <= 0) {
                    deleteState = false
                    deleteViewWidthConstraint.constant = 0
                } else {
                    deleteViewWidthConstraint.constant = deleteState ? maxDeleteWidth : 0
                    editButton?.alpha = deleteState ? 0 : 1
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
//        }
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
        
        self.totalPriceLabel.text = calculateTotalPrice()
        priceTextfield.text = shopItem?.price
        quantityTextfield.text = shopItem?.quantity
        
        backgroundColor = UIColor(hexString: "E5B0EA")
    }
    
    private func calculateTotalPrice() -> String {
        let price = (Double(shopItem!.price) ?? 0.0) * (Double(shopItem!.quantity) ?? 0.0)
        return "R\(price)"
    }
    
}
