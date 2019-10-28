//
//  SheepAnimationView.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/27.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit
import SwiftyGif

class SheepAnimationView: UIView {

    var gifImageView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        do {
            gifImageView = UIImageView(gifImage: try UIImage(gifName: "running-sheep.gif"), loopCount: 1)
        } catch {
            print(error)
        }
            commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor(red: 146, green: 91, blue: 177, alpha: 1)
        guard let gifImageView = gifImageView  else {
            return
        }
        addSubview(gifImageView)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false

    }

}
