//
//  QuestionGroup.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-01-02.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct QuestionGroup {
    public let title: String?
    public let disclaimer: String?
    public let questions: [Question]

    public init(title: String?, disclaimer: String?, questions: [Question]) {
        self.title = title
        self.disclaimer = disclaimer
        self.questions = questions
    }
}
