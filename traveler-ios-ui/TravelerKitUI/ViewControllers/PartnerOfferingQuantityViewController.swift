//
//  PartnerOfferingQuantityViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-12-01.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol PartnerOfferingQuantityViewControllerDelegate: class {
    func partnerOfferingQuantityViewController(_ controller: PartnerOfferingQuantityViewController, didFinishWith: PurchaseForm)
}

open class PartnerOfferingQuantityViewController: UIViewController {
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var stepper: Stepper!
    @IBOutlet weak var priceLabel: UILabel!
    
    var product: PartnerOfferingItem?
    var options: [PartnerOffering]?
    var totalPrice: Price?
    
    weak var delegate: PartnerOfferingQuantityViewControllerDelegate?

    private var purchaseForm: PurchaseForm?
    private var optionsList = ""
    private var quantity = 1

    override open func viewDidLoad() {
        super.viewDidLoad()

        guard let options = options else {
            Log("Options are unavailable", data: nil, level: .error)
            return
        }

        options.forEach { (option) in
            optionsList = optionsList + "·\(option.name)\n"
        }

        listLabel.text = optionsList

        /// Maximum available quantity in stepper is lowest available quantity in options. Otherwise offering can't be successfuly delivered
        guard let leastAvailableOption = options.min(by: {$0.availableQuantity < $1.availableQuantity}) else {
            Log("Can't calculate least available option", data: nil, level: .warning)
            return
        }

        stepper.maximumValue = leastAvailableOption.availableQuantity
        stepper.minimumValue = 1
        stepper.value = 1
        priceLabel.text = totalPrice?.localizedDescriptionInBaseCurrency
    }

    @IBAction func stepperValueDidChange(_ sender: Stepper) {
        quantity = sender.value
        if let totalPrice = totalPrice {
            let newPrice = Price(floatLiteral: totalPrice.valueInBaseCurrency * Double(stepper.value))
            priceLabel.text = newPrice.localizedDescriptionInBaseCurrency
        }
    }

    @IBAction func didPressNext(_ sender: Any) {
        guard let product = product, let options = options else {
            Log("Product or options is nil", data: nil, level: .warning)
            return
        }

        Traveler.fetchPurchaseForm(product: product, options: options, delegate: self)
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as PurchaseQuestionsViewController):
            vc.delegate = self
            vc.purchaseForm = purchaseForm
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension PartnerOfferingQuantityViewController: PurchaseFormFetchDelegate {
    public func purchaseFormFetchDidFailWith(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true)
    }

    public func purchaseFormFetchDidSucceedWith(_ purchaseForm: PurchaseForm) {
        self.purchaseForm = purchaseForm
        performSegue(withIdentifier: "questionsSegue", sender: nil)
    }
}

extension PartnerOfferingQuantityViewController: PurchaseQuestionsViewControllerDelegate {
    public func purchaseQuestionsViewController(_ controller: PurchaseQuestionsViewController, didCheckoutWith purchaseForm: PurchaseForm) {
        delegate?.partnerOfferingQuantityViewController(self, didFinishWith: purchaseForm)
    }
}
