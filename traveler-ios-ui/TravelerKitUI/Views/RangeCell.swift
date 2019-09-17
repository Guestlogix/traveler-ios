//
//  RangeCell.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-09-15.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

@objc protocol RangeCellDelegate {
    func valueDidChangeFor(_ rangeCell: RangeCell)
    @objc optional func updateLabelsFor(_ rangeCell: RangeCell)
}

class RangeCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    
    @IBOutlet weak var rangeSlider: DoubleSliderView!

    public var delegate: RangeCellDelegate?

    public var predeterminedUpperBound: Double? {
        didSet {
            if let minValue = minValue, let maxValue = maxValue {
                rangeSlider.upperValue = (predeterminedUpperBound! - minValue) / (maxValue - minValue)
            }
        }
    }
    public var predeterminedLowerBound: Double? {
        didSet {
            if let minValue = minValue, let maxValue = maxValue {
                rangeSlider.lowerValue = (predeterminedLowerBound! - minValue) / (maxValue - minValue)
            }
        }
    }
    public private(set) var upperBound: Double?
    public private(set) var lowerBound: Double?
    public var minValue: Double?
    public var maxValue: Double?

    override func awakeFromNib() {
        super.awakeFromNib()

        rangeSlider.delegate = self
    }
}

extension RangeCell: DoubleSliderViewDelegate {
    func valueDidChangeFor(_ sliderView: DoubleSliderView) {

        if let minValue = minValue, let maxValue = maxValue {
            upperBound = (sliderView.upperValue! * (maxValue - minValue)) + minValue
            lowerBound = (sliderView.lowerValue! * (maxValue - minValue)) + minValue

            if delegate?.updateLabelsFor?(self) == nil {
                maxValueLabel.text = String((sliderView.upperValue! * (maxValue - minValue)) + minValue)
                minValueLabel.text = String((sliderView.lowerValue! * (maxValue - minValue)) + minValue)
            }

            delegate?.valueDidChangeFor(self)
        }
    }
}
