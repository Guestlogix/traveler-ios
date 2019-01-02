//
//  FormHeaderView.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-01-02.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

class FormHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!

    static func sizeFor(boundingSize: CGSize, title: String, disclaimer: String?) -> CGSize {
        let title = title as NSString
        let disclaimer = disclaimer as NSString?

        var size = CGSize(width: boundingSize.width, height: 0)

        let titleHeight = title.boundingRect(with: boundingSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], context: nil).size.height

        if let disclaimer = disclaimer {
            let disclaimerHeight = disclaimer.boundingRect(with: boundingSize, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil).size.height

            size.height += disclaimerHeight + 16
        }

        size.height += 24 + titleHeight + 16 + 24

        return size
    }
}
