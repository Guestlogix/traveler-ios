//
//  LocationCell.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol LocationCellDelegate: class {
    func locationCellDidPressMapsButton(_ cell: LocationCell)
}

class LocationCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapsButton: UIButton!

    weak var delegate: LocationCellDelegate?

    @IBAction func didPressMapsButton(_ sender: UIButton) {
        delegate?.locationCellDidPressMapsButton(self)
    }

    static func boundingSize(address: String, with boundingSize: CGSize) -> CGSize {
        let titleSize = (address as NSString).boundingRect(with: boundingSize,
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: [.font : UIFont.systemFont(ofSize: 15, weight: .medium)],
                                                           context: nil)

        return CGSize(width: boundingSize.width,
                      height: titleSize.height + 16 + 44 + 16)
    }
}
