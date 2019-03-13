//
//  InputType.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public enum InputType {
    case string
    case list
    case button(String?)
}

let formStringCellIdentifier = "formStringCellIdentifier"
let formListCellIdentifier = "formListCellIdentifier"
let buttonCellIdentifier = "buttonCellIdentifier"

extension InputType {
    var cellIdentifier: String {
        switch self {
        case .string:
            return formStringCellIdentifier
        case .list:
            return formListCellIdentifier
        case .button:
            return buttonCellIdentifier
        }
    }
}
