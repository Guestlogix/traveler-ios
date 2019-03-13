//
//  Question.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-04.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct BookingFormQuestion: Equatable {
    public static func == (lhs: BookingFormQuestion, rhs: BookingFormQuestion) -> Bool {
        return lhs.id == rhs.id
    }

    let id: String
    public let title: String
    public let type: Question.Type
    public let validationRules: [ValidationRule]

    public init(id: String, title: String, type: Question.Type, validationRules: [ValidationRule] = []) {
        self.id = id
        self.title = title
        self.type = type
        self.validationRules = validationRules
    }
}
//
//extension Question {
//    init(passQuestion: PassQuestion, idPrefix: String) {
//        self.init(id: "\(idPrefix)-\(passQuestion.id)", title: passQuestion.title, type: passQuestion.type, validationRules: passQuestion.validationRules)
//    }
//}
