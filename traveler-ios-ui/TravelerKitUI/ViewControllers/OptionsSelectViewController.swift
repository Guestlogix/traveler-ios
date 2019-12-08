//
//  OptionsSelectViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-30.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol OptionsSelectViewControllerDelegate: class {
    func optionsSelectViewController(_ controller: OptionsSelectViewController, didFinishWith purchaseForm: PurchaseForm)
}

open class OptionsSelectViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!

    var optionsGroup: [PartnerOfferingGroup]?
    var product: PartnerOfferingItem?
    weak var delegate: OptionsSelectViewControllerDelegate?

    private var selectedItemIndexes = [Int:Int]() {
        didSet {
            nextButton.isEnabled = selectedItemIndexes.keys.count == optionsGroup?.count ?
                true:false
        }
    }

    private var totalPrice: Price?

    override open func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        nextButton.isEnabled = false
        priceLabel.text = product?.price.localizedDescriptionInBaseCurrency
    }

    @IBAction func didFinishSelection(_ sender: Any){
        var options = [PartnerOffering]()
        selectedItemIndexes.keys.forEach { (sectionIndex) in
            let itemIndex = selectedItemIndexes[sectionIndex]!
            options.append(optionsGroup![sectionIndex].offerings[itemIndex])
        }
        
        performSegue(withIdentifier: "quantitySegue", sender: options)
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case (_, let vc as PartnerOfferingQuantityViewController, let options as [PartnerOffering]):
            vc.product = product
            vc.options = options
            vc.totalPrice = totalPrice
            vc.delegate = self
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension OptionsSelectViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return optionsGroup?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsGroup?[section].offerings.count ?? 0
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return optionsGroup?[section].title
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! InfoCell

        if let currentItem = optionsGroup?[indexPath.section].offerings[indexPath.row], let group = optionsGroup?[indexPath.section] {
            let priceOffset = currentItem.price.valueInBaseCurrency - group.startingPrice.valueInBaseCurrency
            cell.valueLabel.text = priceOffset > 0 ? "+\(Price(floatLiteral: priceOffset).localizedDescriptionInBaseCurrency!)" : "Included"
        }

        cell.titleLabel.text = optionsGroup?[indexPath.section].offerings[indexPath.row].name
        cell.accessoryType = indexPath.row == selectedItemIndexes[indexPath.section] ? .checkmark:.none
        return cell
    }

}

extension OptionsSelectViewController: UITableViewDelegate {
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
            let option = optionsGroup![sectionIndex].offerings[itemIndex]
            let group = optionsGroup![sectionIndex]

            total = total + (option.price.valueInBaseCurrency - group.startingPrice.valueInBaseCurrency)

        }

        totalPrice = Price(floatLiteral: total)

        priceLabel.text = totalPrice?.localizedDescriptionInBaseCurrency
    }
}

extension OptionsSelectViewController: PartnerOfferingQuantityViewControllerDelegate {
    public func partnerOfferingQuantityViewController(_ controller: PartnerOfferingQuantityViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.optionsSelectViewController(self, didFinishWith: purchaseForm)
    }
}

