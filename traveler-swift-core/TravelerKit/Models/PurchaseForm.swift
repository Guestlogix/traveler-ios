//
//  PurchaseForm.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// The different errors that can occur in the `PurchaseForm`
public enum PurchaseFormError: Error {
    /// The `Question` does not belong to the form
    case invalidQuestion
    /// One or more of the `ValidationRule`s failed in a `Question`
    case invalidAnswer(groupIndex: Int, questionIndex: Int, ValidationError)
}

/// A series of grouped questions and answers to those questions
public struct PurchaseForm {
    /// The groups of questions
    public let questionGroups: [QuestionGroup]

    internal private(set) var answers = [String: Answer]()

    let passes: [Pass]
    let product: Product

    init(product: Product, passes: [Pass], questionGroups: [QuestionGroup]) {
        self.questionGroups = questionGroups
        self.passes = passes
        self.product = product

        for question in questionGroups.first?.questions ?? [] {
            guard let suggestedAnswer = question.suggestedAnswer else {
                continue
            }

            switch (question.type, suggestedAnswer) {
            case (.date, let value as Date):
                try? self.addAnswer(DateAnswer(value, question: question))
            case (.quantity, let value as Int):
                try? self.addAnswer(QuantityAnswer(value, question: question))
            case (.string, let value as String):
                try? self.addAnswer(TextualAnswer(value, question: question))
            case (.multipleChoice(let choices), let value as Int) where value < choices.count:
                try? self.addAnswer(MultipleChoiceSelection(value, question: question))
            default:
                Log("Invalid answer", data: suggestedAnswer, level: .error)
                break
            }
        }
    }

    /**
     Adds the supplied answer to the `PurchaseForm`. If the question had already been answered
     this will replace the answer with the new one.

     - Parameters:
     - answer: The `Answer` to add

     - Throws: `PurchaseFormError.invalidQuestion` if the `Question` the supplied `Answer` answers
        did not belong to the form
     */
    public mutating func addAnswer(_ answer: Answer) throws {
        guard questionGroups.contains(where: { $0.questions.contains(where: { $0.id == answer.questionId }) }) else {
            throw PurchaseFormError.invalidQuestion
        }

        answers[answer.questionId] = answer
    }

    /**
     Retrieves a previously added `Answer` from the form for the supplied `Question` if there is any

     - Parameters:
     - question: The `Question` for which to fetch the `Answer`

     - Throws: `PurchaseForm.invalidQuestion` if the `Question` was not part of this form

     - Returns: The previously supplied `Answer`, if none was supplied nil will be returned
     */
    public func answer(for question: Question) throws -> Answer? {
        guard questionGroups.contains(where: { $0.questions.contains(where: { $0 == question }) }) else {
            throw PurchaseFormError.invalidQuestion
        }

        return answers[question.id]
    }

    /**
     Validates all answers in the form, using their respective `Question`s `ValidationRule`

     - Returns: An `Array<PurchaseFormError>` representing all the validation errors inside the form
     */
    public func validate() -> [PurchaseFormError] {
        var errors = [PurchaseFormError]()

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

        return errors
    }
}
