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
    func bookablePurchaseViewController(_ controller: BookablePurchaseViewController, didCreate order: Order)
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
        case (_, let vc as BookableAvailabilityViewController):
            vc.bookingContext = bookingContext
            vc.errorContext = errorContext
            vc.delegate = self
        default:
            Log("Unknown Segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didProceed(_ sender: Any) {
        performSegue(withIdentifier: "dateOptionSegue", sender: nil)
    }
}

extension BookablePurchaseViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard presented is BookableConfirmationViewController else {
            return nil
        }

        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, source: source)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let confirmVC = presented as? BookableConfirmationViewController else {
            return nil
        }

        return DrawerPresentationAnimator(sourceDrawer: self, targetDrawer: confirmVC)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let confirmVC = dismissed as? BookableConfirmationViewController else {
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

extension BookablePurchaseViewController: BookableAvailabilityViewControllerDelegate {
    func bookableAvailabilityViewControllerDidConfirm(_ controller: BookableAvailabilityViewController, bookingForm: BookingForm) {
        ProgressHUD.show()

        Traveler.createOrder(bookingForm: bookingForm, delegate: self)
    }
}

extension BookablePurchaseViewController: OrderCreateDelegate {
    func orderCreationDidSucceed(_ order: Order) {
        ProgressHUD.hide()

        delegate?.bookablePurchaseViewController(self, didCreate: order)
    }

    func orderCreationDidFail(_ error: Error) {
        ProgressHUD.hide()

        let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
