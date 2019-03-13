//
//  InfoCell.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    static func boundingSize(title: String, value: String, with boundingSize: CGSize) -> CGSize {
        let titleSize = (title as NSString).boundingRect(with: boundingSize,
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: [.font : UIFont.systemFont(ofSize: 17, weight: .medium)],
                                                         context: nil)
        let valueSize = (value as NSString).boundingRect(with: boundingSize,
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: [.font : UIFont.systemFont(ofSize: 15)],
                                                         context: nil)

        return CGSize(width: boundingSize.width,
                      height: titleSize.height + valueSize.height + 8 + 12)
    }
}
