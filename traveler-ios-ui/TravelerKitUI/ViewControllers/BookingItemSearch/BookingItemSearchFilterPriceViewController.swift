//
//  BookingItemSearchFilterPriceViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-13.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol BookingItemSearchFilterPriceViewControllerDelegate: class {
    func bookingItemSearchFilterPriceController(_ controller: BookingItemSearchFilterPriceViewController, didFinishWith priceRange: ClosedRange<Double>)
}

open class BookingItemSearchFilterPriceViewController: UIViewController {
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var minPriceField: UITextField!
    @IBOutlet weak var maxPriceField: UITextField!
    
    public var fullRange: ClosedRange<Double>?
    public var currentRange: ClosedRange<Double>?
    
    public weak var delegate: BookingItemSearchFilterPriceViewControllerDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if let fullRange = fullRange {
            priceRangeLabel.text = String(format: "$%.2f - $%.2f", fullRange.lowerBound, fullRange.upperBound)
        }
        
        if let currentRange = currentRange {
            minPriceField.text = String(format: "%.2f", currentRange.lowerBound)
            maxPriceField.text = String(format: "%.2f", currentRange.upperBound)
        }
    }
    
    @IBAction func didApply() {
        guard let minPriceText = minPriceField.text, let newMinPrice = Double(minPriceText), let maxPriceText = maxPriceField.text, let newMaxPrice = Double(maxPriceText), newMaxPrice >= newMinPrice else {
            Log("Minimum price cannot exceed maximum price.", data: nil, level: .error)
            didCancel()
            return
        }
        
        delegate?.bookingItemSearchFilterPriceController(self, didFinishWith: newMinPrice...newMaxPrice)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didCancel() {
        dismiss(animated: true, completion: nil)
    }
}
