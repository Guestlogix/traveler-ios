//
//  Answer.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-01-18.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum AnswerError: Error {
    case unacceptable
}

public protocol Answer {
    var questionId: String { get }
}

public struct MultipleChoiceSelection: Answer {
    public let value: Int
    public let questionId: String

    public init(_ value: Int, question: Question) throws {
        switch question.type {
        case .multipleChoice(let choices) where choices.count > value && value >= 0:
            self.value = value
        default:
            throw AnswerError.unacceptable
        }

        self.questionId = question.id
    }
}

public struct TextualAnswer: Answer {
    public let value: String
    public let questionId: String

    public init(_ value: String, question: Question) throws {
        switch question.type {
        case .string:
            self.value = value
        default:
            throw AnswerError.unacceptable
        }

        self.questionId = question.id
    }

}
