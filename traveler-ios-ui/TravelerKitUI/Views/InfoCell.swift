//
//  InfoCell.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 GuestLogix Inc. All rights reserved.
//

import UIKit

protocol InfoCellDelegate: class {
    func infoCellDidPressButton(_ cell: InfoCell)
}

class InfoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var secondValueLabel: UILabel?
    @IBOutlet weak var infoStackView: UIStackView!

    weak var delegate: InfoCellDelegate?

    @IBAction func didPush(_ sender: Any) {
        delegate?.infoCellDidPressButton(self)
    }

    static func boundingSize(title: String, value: String, with boundingSize: CGSize) -> CGSize {
        let size = CGSize(width: boundingSize.width - 16 - 16, height: 0)       // Left and Right margins

        let titleSize = (title as NSString).boundingRect(with: size,
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: [.font : UIFont.systemFont(ofSize: 17, weight: .medium)],
                                                         context: nil)
        let valueSize = (value as NSString).boundingRect(with: size,
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: [.font : UIFont.systemFont(ofSize: 15)],
                                                         context: nil)

        return CGSize(width: boundingSize.width,
                      height: titleSize.height + valueSize.height + 8 + 12 + 4)
    }
}
