//
//  FormMessage.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-24.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum FormMessage {
    case info(String)
    case alert(String)

    var text: String {
        switch self {
        case .alert(let text):
            return text
        case .info(let text):
            return text
        }
    }
}
