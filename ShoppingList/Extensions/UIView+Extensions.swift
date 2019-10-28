//
//  UIView+Extensions.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/25.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func pinEdgesToSuperview(distance: CGFloat = 0, autoAdd: Bool = true) -> [NSLayoutConstraint] {
        let superview: UIView? = self.superview
        assert(superview != nil, "View's superview must not be nil")
        let left = NSLayoutConstraint(item: self, attribute: .left, toItem: superview, constant: distance)
        let right = NSLayoutConstraint(item: self, attribute: .right, toItem: superview, constant: distance)
        let top = NSLayoutConstraint(item: self, attribute: .top, toItem: superview, constant: distance)
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, toItem: superview, constant: distance)
        if autoAdd {
            let superview: UIView? = self.superview
            superview?.addConstraints([left, right, top, bottom])
        }
        return [left, right, top, bottom]
    }
}

extension NSLayoutConstraint {

    // same attribute, relation = .Equal, multiplier = 1, constant = 0
    convenience init(item view1: AnyObject, attribute attr: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation = .equal, toItem view2: AnyObject?, multiplier: CGFloat = 1, constant c: CGFloat = 0) {
        self.init(item: view1, attribute: attr, relatedBy: relation, toItem: view2, attribute: attr, multiplier: multiplier, constant: c)
    }
}
