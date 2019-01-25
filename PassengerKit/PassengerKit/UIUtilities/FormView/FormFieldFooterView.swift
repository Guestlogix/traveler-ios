//
//  FormFieldFooterView.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-01-24.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit

class FormFieldFooterView: UICollectionReusableView {
    @IBOutlet weak var label: UILabel!

    static func sizeFor(boundingSize: CGSize, text: String) -> CGSize {
        let text = text as NSString

        let size = CGSize(width: boundingSize.width - 20 - 20, height: 0)

        let height = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], context: nil).size.height


        return CGSize(width: boundingSize.width, height: height + 5 + 5)
    }
}
