//
//  PassCell.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-02.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

class PassCell: UITableViewCell {
    @IBOutlet weak var passTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    static func boundingSize(passType: String, value: String, with boundingSize: CGSize) -> CGSize {
        let size = CGSize(width: boundingSize.width - 16 - 16, height: 0)       // Left and Right margins

        let passTypeSize = (passType as NSString).boundingRect(with: size,
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: [.font : UIFont.systemFont(ofSize: 17, weight: .medium)],
                                                         context: nil)
        let valueSize = (value as NSString).boundingRect(with: size,
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: [.font : UIFont.systemFont(ofSize: 15)],
                                                         context: nil)

        return CGSize(width: boundingSize.width,
                      height: passTypeSize.height + valueSize.height + 8 + 12)
    }
}
