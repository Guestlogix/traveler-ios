//
//  InputType.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public enum InputType {
    case string
    case list
}

let formStringCellIdentifier = "formStringCellIdentifier"
let formListCellIdentifier = "formListCellIdentifier"

extension InputType {
    var cellIdentifier: String {
        switch self {
        case .string:
            return formStringCellIdentifier
        case .list:
            return formListCellIdentifier
        }
    }
}
