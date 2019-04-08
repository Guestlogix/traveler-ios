//
//  Answer.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-18.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

/// The different errors that can occur when instantiating an `Answer`
public enum AnswerError: Error {
    /**
     The `Answer` was unacceptable. Occurs when the `Answer` is of a wrong type,
     or in the case of a `MultipleChoiceSelection`, the selected choice was not
     in the original `Question`
     */
    case unacceptable
}

/// A type that holds the answer to a `Question`
public protocol Answer {
    /// The identifier of the `Question`
    var questionId: String { get }
    /// The value that the API understands
    var codedValue: String { get }
}

/// `Answer` to a `Question` of multiple choice type
public struct MultipleChoiceSelection: Answer {
    /// Index representing the selected choice
    public let value: Int
    /// Identifier of the `Question`
    public let questionId: String
    /// Identifier of the selected `Choice`
    public private(set) var codedValue: String

    /**
     Initializes a `MultipleChoiceSelected` given the index of the selected choice
     as well as the `Question` it answers.

     - Parameters:
     - value: Index of the selected `Choice`
     - question: The `Question` this answers

     - Throws: `AnswerError.unacceptable` if the question is not a multiple choice type
        or if the index is out of bounds

     - Returns: A `MultipleChoiceSelection` representing an `Answer` to a multiple choice type question
     */
    public init(_ value: Int, question: Question) throws {
        switch question.type {
        case .multipleChoice(let choices) where choices.count > value && value >= 0:
            self.value = value
            self.codedValue = choices[value].id
        default:
            throw AnswerError.unacceptable
        }

        self.questionId = question.id
    }
}

/// `Answer` to a string type `Question`
public struct TextualAnswer: Answer {
    /// The string used as an answer to the `Question`
    public let value: String
    /// The identifier of the `Question`
    public let questionId: String
    /// The string used as an answer to the `Question`
    public var codedValue: String {
        return value
    }

    /**
     Initializes a `TextualAnswer` given the string and `Question`

     - Parameters:
     - value: The actual answer string
     - question: The `Question` this answers

     - Throws: `AnswerError.unacceptable` if the question is not a string type

     - Returns: A `TextualAnswer` representing an `Answer` to the string type question
     */
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

public struct DateAnswer: Answer {
    public let value: Date
    public let questionId: String
    public var codedValue: String {
        return DateFormatter.dateOnlyFormatter.string(from: value)
    }

    public init(_ value: Date, question: Question) throws {
        switch question.type {
        case .date:
            self.value = value
        default:
            throw AnswerError.unacceptable
        }

        self.questionId = question.id
    }
}

/// `Answer` to a quantity type `Question`
public struct QuantityAnswer: Answer {
    /// The number that was selected
    public let value: Int
    /// The identifier of the `Question`
    public let questionId: String
    /// The string represntation of the number
    public var codedValue: String {
        return String(value)
    }

    /**
     Initializes a `QuantityAnswer` given the number and `Question`

     - Parameters:
     - value: The number represnting the answer
     - question: The `Question` this answers

     - Throws: `AnswerError.unacceptable` if the question is not a quantity type
        or if the number is less than 0

     - Returns: A `QuantityAnswer` representing an `Answer` to the quantity type question
     */
    public init(_ value: Int, question: Question) throws {
        switch question.type {
        case .quantity where value >= 0:
            self.value = value
        default:
            throw AnswerError.unacceptable
        }

        self.questionId = question.id
    }
}
