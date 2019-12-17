//
//  OfferingsSelectViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-30.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol OfferingsSelectViewControllerDelegate: class {
    func offeringsSelectViewController(_ controller: OfferingsSelectViewController, didFinishWith purchaseForm: PurchaseForm)
}

open class OfferingsSelectViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!

    var offeringsGroup: [PartnerOfferingGroup]?
    var product: PartnerOfferingItem?
    weak var delegate: OfferingsSelectViewControllerDelegate?

    let cellIdentifier = "optionCell"

    private var selectedItemIndexes = [Int:Int]() {
        didSet {
            nextButton.isEnabled = selectedItemIndexes.keys.count == offeringsGroup?.count ?
                true : false
        }
    }

    private var totalPrice: Price?

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        
        priceLabel.text = product?.price.localizedDescriptionInBaseCurrency
    }

    @IBAction func didFinishSelection(_ sender: Any){
        var options = [PartnerOffering]()
        selectedItemIndexes.keys.forEach { (sectionIndex) in
            let itemIndex = selectedItemIndexes[sectionIndex]!
            options.append(offeringsGroup![sectionIndex].offerings[itemIndex])
        }
        
        performSegue(withIdentifier: "quantitySegue", sender: options)
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case (_, let vc as PartnerOfferingQuantityViewController, let options as [PartnerOffering]):
            vc.product = product
            vc.selectedOptions = options
            vc.totalPrice = totalPrice
            vc.delegate = self
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension OfferingsSelectViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return offeringsGroup?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offeringsGroup?[section].offerings.count ?? 0
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return offeringsGroup?[section].title
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! InfoCell

        if let currentItem = offeringsGroup?[indexPath.section].offerings[indexPath.row], let group = offeringsGroup?[indexPath.section] {
            let priceOffset = currentItem.price.valueInBaseCurrency - group.startingPrice.valueInBaseCurrency
            cell.valueLabel.text = priceOffset > 0 ? "+\(Price(floatLiteral: priceOffset).localizedDescriptionInBaseCurrency!)" : "Included"
        }

        cell.titleLabel.text = offeringsGroup?[indexPath.section].offerings[indexPath.row].name
        cell.accessoryType = indexPath.row == selectedItemIndexes[indexPath.section] ? .checkmark:.none
        return cell
    }
}

extension OfferingsSelectViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let product = product else {
            Log("Product is nil", data: nil, level: .error)
            return
        }

        var total = product.price.valueInBaseCurrency

        selectedItemIndexes[indexPath.section] = indexPath.row
        tableView.reloadData()

        selectedItemIndexes.keys.forEach { (sectionIndex) in
            let itemIndex = selectedItemIndexes[sectionIndex]!
            let option = offeringsGroup![sectionIndex].offerings[itemIndex]
            let group = offeringsGroup![sectionIndex]

            total = total + (option.price.valueInBaseCurrency - group.startingPrice.valueInBaseCurrency)
        }

        totalPrice = Price(floatLiteral: total)

        priceLabel.text = totalPrice?.localizedDescriptionInBaseCurrency
    }
}

extension OfferingsSelectViewController: PartnerOfferingQuantityViewControllerDelegate {
    public func partnerOfferingQuantityViewController(_ controller: PartnerOfferingQuantityViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.offeringsSelectViewController(self, didFinishWith: purchaseForm)
    }
}

