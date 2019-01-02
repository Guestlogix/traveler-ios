//
//  Question.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-31.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct Question {
    public let id: String
    public let type: Type
    public let value: String

    public enum `Type` {
        case string
        case multipleChoice([Choice])
    }

    public struct Choice {
        let id: String

        public let value: String

        public init(id: String, value: String) {
            self.id = id
            self.value = value
        }
    }

    public init(id: String, type: Type, value: String) {
        self.id = id
        self.type = type
        self.value = value
    }
}
