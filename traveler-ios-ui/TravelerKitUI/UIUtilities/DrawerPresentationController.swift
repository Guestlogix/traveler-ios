//
//  DrawerPresentationController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-10.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

class DrawerPresentationController: UIPresentationController {
    let sourceViewController: UIViewController

    private let dimmingView: UIView

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, source sourceViewController: UIViewController) {
        self.sourceViewController = sourceViewController
        self.dimmingView = UIView()
        self.dimmingView.translatesAutoresizingMaskIntoConstraints = false
        self.dimmingView.alpha = 0
        self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView(_:)))
        self.dimmingView.addGestureRecognizer(gestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return super.frameOfPresentedViewInContainerView
        }

        var frame = super.frameOfPresentedViewInContainerView
        let preferredContentSize = presentedViewController.preferredContentSize
        let height = min(frame.size.height - 164, preferredContentSize.height)
        frame.size.height = height + (frame.size.height - containerView.safeAreaLayoutGuide.layoutFrame.height - containerView.safeAreaLayoutGuide.layoutFrame.origin.y)
        frame.origin.y = UIScreen.main.bounds.height - frame.size.height

        return frame
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }

        let presentedView = presentedViewController.view!
        presentedView.layer.shadowColor = UIColor.black.cgColor
        presentedView.layer.shadowOffset = CGSize(width: 0, height: -1)
        presentedView.layer.shadowRadius = 1
        presentedView.layer.shadowOpacity = 0.1

        containerView.insertSubview(dimmingView, at: 0)
        containerView.addConstraints([
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimmingView.leftAnchor.constraint(equalTo: containerView.leftAnchor)
            ])

        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                self.dimmingView.alpha = 1
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                self.dimmingView.alpha = 0
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 0
        }
    }

    @objc
    func didTapDimmingView(_ sender: Any) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
