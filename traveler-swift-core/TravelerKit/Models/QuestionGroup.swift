//
//  QuestionGroup.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-02.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct QuestionGroup: Decodable {
    public let title: String?
    public let description: String?
    public let questions: [Question]

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case questions = "questions"
    }

    public init(title: String?, description: String?, questions: [Question]) {
        self.title = title
        self.description = description
        self.questions = questions
    }
}
