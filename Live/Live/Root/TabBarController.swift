//
//  TabBarController.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.selectedViewController?.preferredStatusBarStyle ?? .default
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
//            UIColor(0x8CA5FF)
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage(color: .white, size: CGSize(width: 1, height: 1))
        tabBar.backgroundColor = .white
        tabBar.shadowImage = UIImage()
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -6)
        tabBar.layer.shadowOpacity = 0.1
        
        viewControllers = [categroyNav, featuredNav, meNav]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            
    }
    
    //MARK: - Controllers
    lazy var categroyNav: BaseNaviController = {
        let cv = CategoryListController()
        let nav = BaseNaviController(rootViewController: cv)
        let item = UITabBarItem(title: nil, image: UIImage(named: "icon_card"), selectedImage: nil)
        item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        nav.tabBarItem = item
        return nav
    }()
    
    lazy var featuredNav: BaseNaviController = {
        let cv = FeaturedController()
        let nav = BaseNaviController(rootViewController: cv)
        let item = UITabBarItem(title: nil, image: UIImage(named: "icon_about"), selectedImage: nil)
        item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        nav.tabBarItem = item
        return nav
    }()
    
    lazy var meNav: BaseNaviController = {
        let cv = MeController()
        let nav = BaseNaviController(rootViewController: cv)
        let item = UITabBarItem(title: nil, image: UIImage(named: "personal_icon"), selectedImage: nil)
        item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        nav.tabBarItem = item
        return nav
    }()
}

extension TabBarController: UITabBarControllerDelegate {
    
}
