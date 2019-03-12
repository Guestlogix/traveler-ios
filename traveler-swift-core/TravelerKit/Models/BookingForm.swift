//
//  BookingForm.swift
//  PassengerKit
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

    private var answers = [String: Answer]()

    let passes: [Pass]

    public init(passes: [Pass]) {
        let q1 = Question(id: "title", title: "Title", type: .multipleChoice([
            Question.Choice(id: "Mr.", value: "Mr."),
            Question.Choice(id: "Mrs.", value: "Mrs.")
            ]))

        let q2 = Question(id: "firstName", title: "First name", type: .string, validationRules: [.required, .pattern(try! NSRegularExpression(pattern: "^[a-zA-Z ]*$", options: .caseInsensitive))])

        let q3 = Question(id: "lastName", title: "Last name", type: .string, validationRules: [.required, .pattern(try! NSRegularExpression(pattern: "^[a-zA-Z ]*$", options: .caseInsensitive))])

        let q4 = Question(id: "phone", title: "Phone number", type: .string, validationRules: [.required, .pattern(try! NSRegularExpression(pattern: "^\\d*$", options: .caseInsensitive))])

        let q5 = Question(id: "email", title: "Email", type: .string, validationRules: [.required, .pattern(try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive))])

        let primaryContactQuestionGroup = QuestionGroup(title: "Primary Contact", disclaimer: "The primary contact is the person that will receive purchase confirmation and passes. This person does not have to be part of the group", questions: [q1, q2, q3, q4, q5])


        var questionGroups = [QuestionGroup]()

        questionGroups.append(primaryContactQuestionGroup)

        for (index, pass) in passes.enumerated() {
            let questionGroup = QuestionGroup(title: "Guest \(questionGroups.count): \(pass.name)", disclaimer: nil,
                                              questions: pass.questions.map({
                                                Question(id: "\($0.id)-\(index)", title: $0.title, description: $0.description, type: $0.type, validationRules: $0.validationRules)
                                              }))
            questionGroups.append(questionGroup)
        }

        self.questionGroups = questionGroups

        self.passes = passes
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

    public func answers(passAt index: Int) -> [Answer] {
        guard index < passes.count else {
            return []
        }

        return passes[index].questions.compactMap({ answers["\($0.id)-\(index)"] })
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
