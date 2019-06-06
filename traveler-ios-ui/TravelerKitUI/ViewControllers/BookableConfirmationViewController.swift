//
//  BookableConfirmationViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

protocol BookableConfirmationViewControllerDelegate: class {
    func bookableConfirmationViewControllerDidConfirm(_ controller: BookableConfirmationViewController, bookingForm: BookingForm)
}

class BookableConfirmationViewController: UIViewController {
    @IBOutlet weak var confirmContainerView: UIView!
    @IBOutlet weak var passesContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!

    var product: Product?
    var passes: [Pass]?
    weak var delegate: BookableConfirmationViewControllerDelegate?

    private var passQuantities: [Pass: Int]?
    private var bookingForm: BookingForm?
    private var defaultPassQuantities: [Pass: Int]? {
        return passes?.first.flatMap({
            [$0: 1]
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        passQuantities = defaultPassQuantities
        reloadPriceLabel()

        preferredContentSize = view.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0),
                                                            withHorizontalFittingPriority: .required,
                                                            verticalFittingPriority: .defaultLow)

        NotificationCenter.default.addObserver(self, selector: #selector(reloadPriceLabel), name: .preferredCurrencyDidChange, object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let passesVC as PassesViewController):
            passesVC.delegate = self
            passesVC.passes = passes
            passesVC.passQuantities = defaultPassQuantities
        case (_, let vc as BookingQuestionsViewController):
            vc.bookingForm = bookingForm
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @objc
    private func reloadPriceLabel() {
        priceLabel.text = passQuantities?.subTotalDescription(in: TravelerUI.preferredCurrency)
    }

    @IBAction func didContinue(_ sender: Any) {
        guard let product = product, let passes = passQuantities?.allPasses else {
            Log("No Product/Passes", data: nil, level: .error)
            return
        }

        confirmButton.isEnabled = false

        Traveler.fetchBookingForm(product: product, passes: passes, delegate: self)
    }
}

extension BookableConfirmationViewController: DrawerTransitioning {
    func drawerViewForTransition(context: UIViewControllerContextTransitioning) -> UIView {
        return confirmContainerView
    }
}

extension BookableConfirmationViewController: PassesViewControllerDelegate {
    func passesViewControllerDidChangePreferredContentSize(_ controller: PassesViewController) {
        passesContainerHeightConstraint.constant = controller.preferredContentSize.height
    }

    func passesViewControllerDidChangeQuantities(_ controller: PassesViewController) {
        self.passQuantities = controller.passQuantities
        reloadPriceLabel()
    }
}

extension BookableConfirmationViewController: BookingQuestionsViewControllerDelegate {
    func bookingQuestionsViewControllerDidCheckout(_ controller: BookingQuestionsViewController) {
        guard let bookingForm = controller.bookingForm else {
            Log("No BookingForm", data: nil, level: .error)
            return
        }

        delegate?.bookableConfirmationViewControllerDidConfirm(self, bookingForm: bookingForm)
    }
}

extension BookableConfirmationViewController: BookingFormFetchDelegate {
    func bookingFormFetchDidFailWith(_ error: Error) {
        confirmButton.isEnabled = true

        // TODO: Should cast Error correctly to a known error, OR better the custom error should override localizedDescription

        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true)
    }

    func bookingFormFetchDidSucceedWith(_ bookingForm: BookingForm) {
        confirmButton.isEnabled = true

        self.bookingForm = bookingForm

        performSegue(withIdentifier: "questionsSegue", sender: nil)
    }
}

extension Dictionary where Key == Pass, Value == Int {
    var allPasses: [Pass] {
        var passes = [Pass]()
        for (pass, quantity) in self {
            for _ in 0..<quantity {
                passes.append(pass)
            }
        }
        return passes
    }
}
