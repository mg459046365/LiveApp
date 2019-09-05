//
//  BaseNaviController.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import UIKit

class BaseNaviController: UINavigationController {
    /// 正在pushing
    private var isPushing = false

    /// 正在poping
    private var isPoping = false

    /// 正在pushing的vc
    private var pushingController: UIViewController?

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

    override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? false
    }

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor(0x333333), .font: UIFont.boldSystemFont(ofSize: 16)]
        navigationBar.tintColor = UIColor(red:81/255, green:82/255,blue:112/255,alpha:1.00)
        navigationBar.backgroundColor = .white
        navigationBar.setBackgroundImage(UIImage(color: .white, size: CGSize(width: 1, height: 1)), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()
        
        
        
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = false
        delegate = self
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if isPoping { return }
        if isPushing, let vc = self.pushingController, vc.isKind(of: type(of: viewController)) { return }
        isPushing = true
        interactivePopGestureRecognizer?.isEnabled = false
        pushingController = viewController
        super.pushViewController(viewController, animated: animated)
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if isPushing || isPoping { return viewControllers }
        isPoping = true
        interactivePopGestureRecognizer?.isEnabled = false
        return super.popToViewController(viewController, animated: animated)
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if isPushing || isPoping { return viewControllers }
        isPoping = true
        interactivePopGestureRecognizer?.isEnabled = false
        return super.popToRootViewController(animated: animated)
    }
}

extension BaseNaviController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isPushing = false
        isPoping = false
        interactivePopGestureRecognizer?.isEnabled = true
        navigationController.interactivePopGestureRecognizer?.isEnabled = (navigationController.viewControllers.count > 0)
    }
}

extension BaseNaviController: UIGestureRecognizerDelegate {
    
}
