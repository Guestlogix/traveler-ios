//
//  PurchasablesViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-03.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import PassengerKit




/*

extension PurchasableGroupsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let groupIndex = selectedGroupIndex, let purchasableIndex = selectedPurchasableIndex, let vc = presented as? PurchasableViewController else {
            return nil
        }

        let cell = tableView.cellForRow(at: IndexPath(row: groupIndex, section: 0)) as! CarouselViewCell
        let itemCell = cell.collectionView.cellForItem(at: IndexPath(item: purchasableIndex, section: 0)) as! CarouselItemViewCell

        return Animator(fromView: itemCell.imageContainerView, toView: vc.imageContainerView)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let groupIndex = selectedGroupIndex, let purchasableIndex = selectedPurchasableIndex, let vc = dismissed as? PurchasableViewController else {
            return nil
        }

        let cell = tableView.cellForRow(at: IndexPath(row: groupIndex, section: 0)) as! CarouselViewCell
        let itemCell = cell.collectionView.cellForItem(at: IndexPath(item: purchasableIndex, section: 0)) as! CarouselItemViewCell

        return nil
    }
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    let fromView: UIView
    let toView: UIView

    init(fromView: UIView, toView: UIView) {
        self.fromView = fromView
        self.toView = toView
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let container = transitionContext.containerView
        let fromView = self.fromView
        let toView = self.toView

        toVC.view.setNeedsLayout()
        toVC.view.layoutIfNeeded()

        let snapshot = fromView.snapshotView(afterScreenUpdates: false)!
        fromView.isHidden = true
        toView.isHidden = true

        toVC.view.alpha = 0
        let finalFrame = transitionContext.finalFrame(for: toVC)
        var frame = finalFrame
        frame.origin.y += frame.size.height
        toVC.view.frame = frame
        container.addSubview(toVC.view)

        snapshot.frame = container.convert(fromView.bounds, from: fromView)
        container.addSubview(snapshot)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.alpha = 1
            toVC.view.frame = finalFrame
            snapshot.frame = container.convert(toView.frame, from: toView)
        }) { (finished) in
            fromView.isHidden = false
            toView.isHidden = false
            snapshot.removeFromSuperview()

            transitionContext.completeTransition(finished)
        }
    }
}
*/
