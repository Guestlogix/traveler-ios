//
//  Question.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-31.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct Question: Decodable, Equatable {
    public static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.id == rhs.id
    }

    /// Identifier
    public let id: String
    /// Type of question
    public let type: Type
    /// The caption
    public let title: String
    /// An optional description
    public let description: String?
    /// Validation rules
    public let validationRules: [ValidationRule]

    /// Different questions types, with associated value as the suggestedAnswer 
    public enum `Type` {
        /// Integer
        case quantity(Int?)
        /// Date 
        case date(Date?)
        /// Textual
        case string(String?)
        /// Multiple choice
        case multipleChoice([Choice], Int?)
    }

    /// Information about a `Choice` for multiple choice type questions
    public struct Choice: Decodable {
        let id: String

        /// The caption
        public let value: String

        enum CodingKeys: String, CodingKey {
            case id     = "id"
            case value  = "label"
        }

        init(id: String, value: String) {
            self.id = id
            self.value = value
        }
    }

    enum CodingKeys: String, CodingKey {
        case id             = "id"
        case title          = "title"
        case description    = "description"
        case required       = "required"
        case type           = "type"
        case choices        = "choices"
        case suggestedAnswer = "suggestedAnswer"
    }

    init(id: String, title: String, description: String? = nil, type: Type, validationRules: [ValidationRule] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.validationRules = validationRules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String?.self, forKey: .description)

        if try container.decode(Bool.self, forKey: .required) {
            self.validationRules = [.required]
        } else {
            self.validationRules = []
        }

        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "Date":
            let suggestedAnswer = try container.decode(Date?.self, forKey: .suggestedAnswer)
            self.type = .date(suggestedAnswer)
        case "Quantity":
            let suggestedAnswer = try container.decode(Int?.self, forKey: .suggestedAnswer)
            self.type = .quantity(suggestedAnswer)
        case "Text":
            let suggestedAnswer = try container.decode(String?.self, forKey: .suggestedAnswer)
            self.type = .string(suggestedAnswer)
        case "MultipleChoice":
            let choices = try container.decode([Question.Choice].self, forKey: .choices)
            let choiceId = try container.decode(String?.self, forKey: .suggestedAnswer)
            let suggestedAnswer = choices.firstIndex(where: {$0.id == choiceId})
            self.type = .multipleChoice(choices, suggestedAnswer)
        default:
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.type, in: container, debugDescription: "Unknown type")
        }
    }
}
