//
//  LaunchViewController.swift
//  ShoppingList
//
//  Created by Matthew Mashiane on 2019/10/27.
//  Copyright © 2019 Matthew Mashiane. All rights reserved.
//

import UIKit
import SwiftyGif

class LaunchViewController: UIViewController {

    let sheepAnimationView = SheepAnimationView()

        override func viewDidLoad() {
            super.viewDidLoad()
            view.addSubview(sheepAnimationView)
            let _ = sheepAnimationView.pinEdgesToSuperview()
            sheepAnimationView.gifImageView?.delegate = self
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            sheepAnimationView.gifImageView?.animationDuration = 0.5
            sheepAnimationView.gifImageView?.startAnimatingGif()
        }

    }

    extension LaunchViewController: SwiftyGifDelegate {
        func gifDidStop(sender: UIImageView) {
            let shopsList = ShopListRouter.createShopListModule()
            self.present(shopsList, animated: true, completion: nil)
        }
    }
