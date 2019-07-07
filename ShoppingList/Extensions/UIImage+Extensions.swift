//
//  UIImage+Extensions.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/07/06.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit

extension UIImage {
    func scaledWidth(to maxSize: CGFloat) -> UIImage? {
        let aspectRatio: CGFloat = maxSize / size.width
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }
    
    func scaledHeight(to maxSize: CGFloat) -> UIImage? {
        let aspectRatio: CGFloat = maxSize / size.height
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }
    
}
