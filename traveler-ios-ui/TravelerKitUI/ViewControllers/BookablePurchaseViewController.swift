//
//  BookablePurchaseViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

protocol BookablePurchaseViewControllerDelegate: class {
    func bookablePurchaseViewController(_ controller: BookablePurchaseViewController, didFinishWith bookingForm: BookingForm)
}

class BookablePurchaseViewController: UIViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!

    var product: BookingItem?
    weak var delegate: BookablePurchaseViewControllerDelegate?

    private var order: Order?

    override func viewDidLoad() {
        super.viewDidLoad()

        priceLabel.text = product?.price.localizedDescriptionInBaseCurrency
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookingConfirmationViewController):
            vc.product = product
            vc.delegate = self
        case (_, let vc as PaymentConfirmationViewController):
            vc.order = order
        default:
            Log("Unknown Segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didProceed(_ sender: Any) {
        performSegue(withIdentifier: "confirmationSegue", sender: nil)
    }
}

extension BookablePurchaseViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard presented is BookingPassesViewController else {
            return nil
        }

        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, source: source)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let confirmVC = presented as? BookingPassesViewController else {
            return nil
        }

        return DrawerPresentationAnimator(sourceDrawer: self, targetDrawer: confirmVC)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let confirmVC = dismissed as? BookingPassesViewController else {
            return nil
        }

        return DrawerDismmissalAnimator(sourceDrawer: confirmVC, targetDrawer: self)
    }
}

extension BookablePurchaseViewController: DrawerTransitioning {
    func drawerViewForTransition(context: UIViewControllerContextTransitioning) -> UIView {
        return view
    }
}

extension BookablePurchaseViewController: BookingConfirmationViewControllerDelegate {
    func bookingConfirmationViewController(_ controller: BookingConfirmationViewController, didFinishWith bookingForm: BookingForm) {
        delegate?.bookablePurchaseViewController(self, didFinishWith: bookingForm)
    }
}
