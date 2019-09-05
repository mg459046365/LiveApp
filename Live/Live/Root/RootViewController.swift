//
//  RootViewController.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {

    private let tabCV = TabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        showTabVC()
    }
    
    private func showTabVC() {
        addChild(tabCV)
        view.addSubview(tabCV.view)
        tabCV.didMove(toParent: self)
    }
    
}
