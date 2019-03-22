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

    public let id: String
    public let type: Type
    public let title: String
    public let description: String?
    public let validationRules: [ValidationRule]

    public enum `Type` {
        case string
        case multipleChoice([Choice])
    }

    public struct Choice: Decodable {
        let id: String

        public let value: String

        enum CodingKeys: String, CodingKey {
            case id     = "id"
            case value  = "name"
        }

        public init(id: String, value: String) {
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
        case "Text":
            self.type = .string
        case "MultipleChoice":
            let choices = try container.decode([Question.Choice].self, forKey: .choices)

            self.type = .multipleChoice(choices)
        default:
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.type, in: container, debugDescription: "Unknown type")
        }
    }
}
