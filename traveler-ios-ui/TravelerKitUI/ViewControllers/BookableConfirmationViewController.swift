//
//  BookableConfirmationViewController.swift
//  PassengerKit
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

    var passes: [Pass]?
    weak var delegate: BookableConfirmationViewControllerDelegate?

    private var passQuantities: [Pass: Int]?

    override func viewDidLoad() {
        super.viewDidLoad()

        passQuantities = passes?.defaultPassQuantities ?? [:]
        reloadPriceLabel()

        preferredContentSize = view.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0),
                                                            withHorizontalFittingPriority: .required,
                                                            verticalFittingPriority: .defaultLow)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let passesVC as PassesViewController):
            passesVC.delegate = self
            passesVC.passes = passes
            passesVC.passQuantities = passes?.defaultPassQuantities
        case (_, let vc as BookingQuestionsViewController):
            vc.bookingForm = BookingForm(passes: passQuantities?.allPasses ?? [])
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    private func reloadPriceLabel() {
        priceLabel.text = passQuantities?.subTotalDescription
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
