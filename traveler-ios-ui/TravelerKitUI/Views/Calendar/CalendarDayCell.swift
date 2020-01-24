//
//  CalendarDayCell.swift
//  TravelerKitUI
//
//  Created by Josip Petric on 23/01/2020.
//  Copyright © 2020 GuestLogix. All rights reserved.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var selectionIndicatorView: UIView!
    
    var availabilityState: AvailabilityState = .notDetermined {
        didSet {
            availabilityStateChanged(availabilityState)
        }
    }
    
    var selectionIndicatorColor: UIColor?
    var selectionIndicatorTextColor: UIColor? = .black
    
    private var availableColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor.black
        }
    }
    
    private var unavailableColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.quaternaryLabel
        } else {
            return UIColor.lightGray
        }
    }
    
    override var bounds: CGRect {
        didSet {
            layoutIfNeeded()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            selectedStateChanged()
        }
    }

    private var strikeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionIndicatorView.isHidden = true
        selectionIndicatorView.layer.masksToBounds = true
        if #available(iOS 13.0, *) {
            valueLabel.textColor = UIColor.label
        } else {
            valueLabel.textColor = UIColor.black
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionIndicatorView.layer.cornerRadius = selectionIndicatorView.frame.height / 2
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width / 3, y: bounds.height - bounds.height / 3))
        path.addLine(to: CGPoint(x: bounds.width - bounds.width / 3, y: bounds.height / 3))
        
        strikeLayer.path = path.cgPath
        strikeLayer.strokeColor = unavailableColor.cgColor
        strikeLayer.position = CGPoint.zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        selectionIndicatorView.isHidden = true
        strikeLayer.removeFromSuperlayer()
    }
    
    private func selectedStateChanged() {
        selectionIndicatorView.backgroundColor = selectionIndicatorColor
        valueLabel.textColor = isSelected ? selectionIndicatorTextColor : availableColor
        selectionIndicatorView.isHidden = !isSelected
    }
    
    private func availabilityStateChanged(_ availabilityState: AvailabilityState) {
        strikeLayer.removeFromSuperlayer()
        
        switch availabilityState {
        case .available:
            valueLabel.textColor = isSelected ? selectionIndicatorTextColor : availableColor
            isUserInteractionEnabled = true
        case .unavailable:
            valueLabel.textColor = isSelected ? selectionIndicatorTextColor : unavailableColor
            layer.addSublayer(strikeLayer)
            isUserInteractionEnabled = false
        case .notDetermined:
            valueLabel.textColor = isSelected ? selectionIndicatorTextColor : unavailableColor
            isUserInteractionEnabled = false
        }
    }
}
