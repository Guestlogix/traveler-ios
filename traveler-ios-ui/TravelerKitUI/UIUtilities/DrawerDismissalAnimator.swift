//
//  DrawerDismissalAnimator.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-10.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

class DrawerDismmissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
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
        let fromView = transitionContext.view(forKey: .from)!
        let sourceDrawerView = sourceDrawer.drawerViewForTransition(context: transitionContext)
        let sourceDrawerSnapshot = sourceDrawerView.snapshotView(afterScreenUpdates: false)!
        let container = transitionContext.containerView

        sourceDrawerView.isHidden = true

        container.addSubview(sourceDrawerSnapshot)

        sourceDrawerSnapshot.frame = container.convert(sourceDrawerView.bounds, from: sourceDrawerView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame.origin.y = container.frame.height - sourceDrawerView.frame.height
        }, completion: { (finished) in
            sourceDrawerView.isHidden = false
            sourceDrawerSnapshot.removeFromSuperview()

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
