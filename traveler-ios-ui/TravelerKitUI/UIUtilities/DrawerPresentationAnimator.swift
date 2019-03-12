//
//  DrawerPresentationAnimator.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-10.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

class DrawerPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let sourceDrawer: DrawerTransitioning
    let targetDrawer: DrawerTransitioning

    init(sourceDrawer: DrawerTransitioning, targetDrawer: DrawerTransitioning) {
        self.sourceDrawer = sourceDrawer
        self.targetDrawer = targetDrawer

        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let toView = transitionContext.view(forKey: .to)!
        let container = transitionContext.containerView
        let sourceDrawerView = sourceDrawer.drawerViewForTransition(context: transitionContext)
        let targetDrawerView = targetDrawer.drawerViewForTransition(context: transitionContext)
        let sourceDrawerSnapshot = sourceDrawerView.snapshotView(afterScreenUpdates: false)!

        sourceDrawerView.isHidden = true
        targetDrawerView.isHidden = true

        container.addSubview(toView)
        container.addSubview(sourceDrawerSnapshot)

        sourceDrawerSnapshot.frame = container.convert(sourceDrawerView.bounds, from: sourceDrawerView)
        toView.frame.origin.y = toView.frame.height - sourceDrawerView.frame.height

        let finalFrame = transitionContext.finalFrame(for: toVC)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.frame = finalFrame
        }, completion: { finished in
            targetDrawerView.isHidden = false
            sourceDrawerView.isHidden = false
            sourceDrawerSnapshot.removeFromSuperview()

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
