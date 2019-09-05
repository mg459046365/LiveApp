//
//  ColorDetailController.swift
//  Live
//
//  Created by Beryter on 2019/9/4.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class ColorDetailController: BaseViewController {
    let disposeBag = DisposeBag()
    let color: LiveColor
    var transitionView: UIView?
    lazy var openTransition: BYOpenTransition = {
        let tr = BYOpenTransition()
        tr.delegate = self
        return tr
    }()

    lazy var closeTransition: BYCloseTransition = {
        let tr = BYCloseTransition()
        tr.delegate = self
        return tr
    }()

    init(color: LiveColor) {
        self.color = color
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color.color
        transitioningDelegate = self
        modalPresentationStyle = .custom
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 20, y: Constants.statusNavHeight, width: 60, height: 44)
        btn.setTitle("返回", for: .normal)
        btn.setTitleColor(color.color.getClearTextColor(), for: .normal)
        btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        view.addSubview(btn)
    }
}

extension ColorDetailController: BYTransitionDelegate {
    func transitionView(_ transition: BYTransition) -> UIView? {
        if transition.type == .open {
            return transitionView
        }
        let imageView = UIImageView(image: UIImage(color: color.color, size: CGSize(width: 1, height: 1)))
        imageView.frame = view.bounds
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }

    func transitionToFrame(_ transition: BYTransition) -> CGRect {
        if transition.type == .open {
            return UIScreen.main.bounds
        }
        return transitionView?.frame ?? CGRect(x: view.by_width / 2, y: view.by_height / 2, width: 0, height: 0)
    }
}

extension ColorDetailController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return openTransition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return closeTransition
    }
}
