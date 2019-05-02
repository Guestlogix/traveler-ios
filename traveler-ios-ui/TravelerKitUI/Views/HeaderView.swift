//
//  HeaderView.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!

    static func boundingSize(with boundingSize: CGSize, title: String?, disclaimer: String?) -> CGSize {
        var size = CGSize(width: boundingSize.width - 16 - 16, height: 0)       // Left and Right margins

        if let title = title as NSString? {
            size.height += title.boundingRect(with: CGSize(width: size.width, height: 0),
                                              options: .usesFontLeading,
                                              attributes: [.font : UIFont.boldSystemFont(ofSize: 17)],
                                              context: nil).height
        }

        if let disclaimer = disclaimer as NSString? {
            size.height += disclaimer.boundingRect(with: CGSize(width: size.width, height: 0),
                                                   options: .usesFontLeading,
                                                   attributes: [.font : UIFont.systemFont(ofSize: 16)],
                                                   context: nil).height
        }

        size.height += 32 + 8 + 32      // Top and Bottom margins

        return CGSize(width: boundingSize.width, height: size.height)
    }
}
