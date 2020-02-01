//
//  Validation.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-24.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

/// The different validation rules a `Question` can have
public enum ValidationRule {
    /// It must be answered
    case required
    /// The answer must match the given RegEx pattern
    case pattern(pattern: NSRegularExpression, message: String)
}

private enum ValidationType:String, Decodable {
    case required = "Required"
    case regex = "Regex"
}

struct AnyValidationRule: Decodable {
    var payload: ValidationRule

    private let type: ValidationType
    private let validationRule: String?
    private let message: String?

    enum CodingKeys: String, CodingKey  {
        case type = "validationType"
        case validationRule = "validationRule"
        case message = "message"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(ValidationType.self, forKey: .type)
        self.validationRule = try container.decode(String?.self, forKey: .validationRule)
        self.message = try container.decode(String?.self, forKey: .message)

        switch type {
        case .required:
            self.payload = .required
        case .regex:
            guard let rule = validationRule , let regularExpression = try? NSRegularExpression(pattern: rule) else {
                throw DecodingError.dataCorruptedError(forKey: CodingKeys.validationRule, in: container, debugDescription: "Bad regex")
            }

            guard let message = message else {
                throw DecodingError.dataCorruptedError(forKey: CodingKeys.message, in: container, debugDescription: "Missing message for regex")
            }

            self.payload = .pattern(pattern: regularExpression, message: message)
        }
    }
}
