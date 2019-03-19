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
    @IBOutlet weak var button: UIButton!

    var errorContext: ErrorContext?
    var bookingContext: BookingContext?
    weak var delegate: BookablePurchaseViewControllerDelegate?

    /// TEMP

    private var passes: [Pass]?

    /// END TEMP

    override func viewDidLoad() {
        super.viewDidLoad()

        //priceLabel.text = bookingContext?.product.price.localizedDescription

        bookingContext?.addObserver(self)
    }

    deinit {
        bookingContext?.removeObserver(self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookableConfirmationViewController):
            vc.modalPresentationStyle = .custom
            vc.modalPresentationCapturesStatusBarAppearance = true
            vc.transitioningDelegate = self
            vc.passes = passes
            vc.delegate = self
        default:
            break
        }
    }

    @IBAction func didPressCTA(_ sender: UIButton) {
        guard let bookingContext = bookingContext else {
            Log("No BookingContext", data: nil, level: .error)
            return
        }

        guard let availability = bookingContext.selectedAvailability else {
            errorContext?.error = BookingError.noDate
            return
        }

        button.isEnabled = false

        Traveler.fetchPasses(product: bookingContext.product, availability: availability, option: bookingContext.selectedOption, delegate: self)
    }
}

extension BookablePurchaseViewController: PassFetchDelegate {
    func passFetchDidSucceedWith(_ result: [Pass]) {
        self.passes = result

        performSegue(withIdentifier: "passSegue", sender: nil)

        button.isEnabled = true
    }

    func passFetchDidFailWith(_ error: Error) {
        button.isEnabled = true

        // TODO: handle error case when max quantity has been reached

        errorContext?.error = error
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

extension BookablePurchaseViewController: BookingContextObserving {
    func bookingContextDidUpdate(_ context: BookingContext) {
        button.isEnabled = context.isReady
    }
}

extension BookablePurchaseViewController: BookableConfirmationViewControllerDelegate {
    func bookableConfirmationViewControllerDidConfirm(_ controller: BookableConfirmationViewController, bookingForm: BookingForm) {
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
