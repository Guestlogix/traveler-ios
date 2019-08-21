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
    func bookablePurchaseViewControllerDidReceiveConfirmation(_ controller: BookablePurchaseViewController, with form: BookingForm)
}

class BookablePurchaseViewController: UIViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!

    var errorContext: ErrorContext?
    var bookingContext: BookingContext?
    weak var delegate: BookablePurchaseViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        priceLabel.text = bookingContext?.product.price.localizedDescriptionInBaseCurrency
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookableConfirmationViewController):
            vc.bookingContext = bookingContext
            vc.errorContext = errorContext
            vc.delegate = self
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
        guard presented is BookablePassesViewController else {
            return nil
        }

        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, source: source)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let confirmVC = presented as? BookablePassesViewController else {
            return nil
        }

        return DrawerPresentationAnimator(sourceDrawer: self, targetDrawer: confirmVC)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let confirmVC = dismissed as? BookablePassesViewController else {
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

extension BookablePurchaseViewController: BookableConfirmationViewControllerDelegate {
    func bookableConfirmationViewControllerDidConfirm(_ controller: BookableConfirmationViewController, with form: BookingForm) {
        delegate?.bookablePurchaseViewControllerDidReceiveConfirmation(self, with: form)
    }
}
