//
//  DoubleSliderView.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-09-15.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

protocol DoubleSliderViewDelegate {
    func valueDidChangeFor(_ sliderView: DoubleSliderView)
}

class DoubleSliderView: UIView {

    let rangeSlider = DoubleSlider(frame: CGRect.zero)
    public var upperValue: Double? {
        didSet {
            layoutSubviews()
        }
    }
    public var lowerValue: Double? {
        didSet {
            layoutSubviews()
        }
    }

    public var delegate: DoubleSliderViewDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        if let upperValue = upperValue, let lowerValue = lowerValue {
            rangeSlider.upperValue = upperValue
            rangeSlider.lowerValue = lowerValue
        }
        rangeSlider.frame = bounds
        self.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

    @objc func sliderValueChanged(_ sender: DoubleSlider) {
        upperValue = sender.upperValue
        lowerValue = sender.lowerValue
        delegate?.valueDidChangeFor(self)
    }
}
