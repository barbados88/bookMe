//
//  TabBarController.swift
//  BookMe
//
//  Created by mac on 31.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    static let shared = TabBarController()
    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?[0] {
            TabBarController.shared.index = 0
            first()
        } else if item == tabBar.items?[1] {
            TabBarController.shared.index = 1
            second()
        } else if item == tabBar.items?[2] {
            TabBarController.shared.index = 2
            third()
        } else if item == tabBar.items?[3] {
            TabBarController.shared.index = 3
            fourth()
        } else if item == tabBar.items?[4] {
            TabBarController.shared.index = 4
            fifth()
        }
    }
    
    @objc private func first() {
        NotificationCenter.default.post(name: .firstTab, object: nil)
    }
    
    @objc private func second() {
        NotificationCenter.default.post(name: .secondTab, object: nil)
    }
    
    @objc private func third() {
        NotificationCenter.default.post(name: .thirdTab, object: nil)
    }
    
    @objc private func fourth() {
        NotificationCenter.default.post(name: .fourthTab, object: nil)
    }
    
    @objc private func fifth() {
        NotificationCenter.default.post(name: .fifthTab, object: nil)
    }
    
}
