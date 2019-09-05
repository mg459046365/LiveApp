//
//  OpenColorDetailTransition.swift
//  Live
//
//  Created by Beryter on 2019/9/4.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

protocol BYTransitionDelegate: AnyObject {
    func transitionView(_ transition: BYTransition) -> UIView?
    func transitionToFrame(_ transition: BYTransition) -> CGRect
}

class BYTransition: NSObject, UIViewControllerAnimatedTransitioning {
    enum BYTransitionType {
        case open
        case close
    }

    let type: BYTransitionType
    weak var delegate: BYTransitionDelegate?
    init(type: BYTransitionType) {
        self.type = type
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }
}

class BYOpenTransition: BYTransition {
    init() {
        super.init(type: .open)
    }

    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVc = transitionContext.viewController(forKey: .to), let toView = toVc.view else {
            transitionContext.completeTransition(true)
            return
        }
        guard let trv = delegate?.transitionView(self) else {
            transitionContext.completeTransition(true)
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(trv)
        let oldFrame = trv.frame
        let toFrame = delegate?.transitionToFrame(self) ?? UIScreen.main.bounds
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            trv.frame = toFrame
        }) { _ in
            trv.removeFromSuperview()
            trv.frame = oldFrame
            containerView.insertSubview(toView, at: 0)
            transitionContext.completeTransition(true)
        }
    }
}

class BYCloseTransition: BYTransition {
    init() {
        super.init(type: .close)
    }

    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVc = transitionContext.viewController(forKey: .from), let fromView = fromVc.view else {
            transitionContext.completeTransition(true)
            return
        }
        guard let trv = delegate?.transitionView(self) else {
            transitionContext.completeTransition(true)
            return
        }
        guard let toVc = transitionContext.viewController(forKey: .to), let toView = toVc.view else {
            transitionContext.completeTransition(true)
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(trv)
        containerView.insertSubview(toView, at: 0)
        fromView.alpha = 0
        let toFrame = delegate?.transitionToFrame(self) ?? CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            trv.frame = toFrame
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled {
                fromView.alpha = 1
            }
            trv.removeFromSuperview()
        }
    }
}
