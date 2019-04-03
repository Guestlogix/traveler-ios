//
//  QuestionGroup.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-02.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

/// Holds `Question`s that are grouped together
public struct QuestionGroup: Decodable {
    /// An optional title/header for the group
    public let title: String?
    /// An optional disclaimer that provides a description for the group
    public let disclaimer: String?
    /// The `Array<Question>` in this group
    public let questions: [Question]

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case disclaimer = "description"
        case questions = "questions"
    }

    init(title: String?, disclaimer: String?, questions: [Question]) {
        self.title = title
        self.disclaimer = disclaimer
        self.questions = questions
    }
}
