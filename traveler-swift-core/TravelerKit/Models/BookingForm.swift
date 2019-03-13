//
//  BookingForm.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum BookingFormError: Error {
    case invalidQuestion
    case invalidAnswer(groupIndex: Int, questionIndex: Int, ValidationError)
}

public struct BookingForm {
    public let questionGroups: [QuestionGroup]

    internal private(set) var answers = [String: Answer]()

    let passes: [Pass]
    let product: Product

    public init(product: Product, passes: [Pass], questionGroups: [QuestionGroup]) {
        self.questionGroups = questionGroups
        self.passes = passes
        self.product = product
    }

    public mutating func addAnswer(_ answer: Answer) throws {
        guard questionGroups.contains(where: { $0.questions.contains(where: { $0.id == answer.questionId }) }) else {
            throw BookingFormError.invalidQuestion
        }

        answers[answer.questionId] = answer
    }

    public func answer(for question: Question) throws -> Answer? {
        guard questionGroups.contains(where: { $0.questions.contains(where: { $0 == question }) }) else {
            throw BookingFormError.invalidQuestion
        }

        return answers[question.id]
    }

    public func validate(completion: (([BookingFormError]) -> Void)) {
        var errors = [BookingFormError]()

        for (groupIndex, group) in questionGroups.enumerated() {
            for (questionIndex, question) in group.questions.enumerated() {
                let answer = answers[question.id]

                for validation in question.validationRules {
                    switch (validation, answer) {
                    case (.required, .none):
                        errors.append(.invalidAnswer(groupIndex: groupIndex, questionIndex: questionIndex, .required(question)))
                    case (.pattern(let regex), let answer as TextualAnswer) where regex.firstMatch(in: answer.value, options: [], range: NSRange(location: 0, length: answer.value.count)) == nil:
                        errors.append(.invalidAnswer(groupIndex: groupIndex, questionIndex: questionIndex, .invalidFormat(question)))
                    default:
                        break
                    }
                }
            }
        }

        completion(errors)
    }
}
