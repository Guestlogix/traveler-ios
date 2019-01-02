//
//  BookingQuestionsViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-31.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

class BookingQuestionsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var formView: FormView!

    var questionGroups: [QuestionGroup]?

    override func viewDidLoad() {
        super.viewDidLoad()

        /// TEMP

        let q1 = Question(id: "title", type: .multipleChoice([
            Question.Choice(id: "c1", value: "Mr."),
            Question.Choice(id: "c1", value: "Mrs.")
            ]), value: "Title")

        let q2 = Question(id: "name", type: .string, value: "First name")

        let q3 = Question(id: "lastName", type: .string, value: "Last name")

        let q4 = Question(id: "phoneNumber", type: .string, value: "Phone number")

        let q5 = Question(id: "email", type: .string, value: "Email")

        self.questionGroups = [QuestionGroup(title: "Primary Contact", disclaimer: "The primary contact is the person that will receive purchase confirmation and passes. This person does not have to be part of the group", questions: [q1, q2, q3, q4, q5])]

        /// END TEMP

        formView.dataSource = self
        formView.delegate = self
        formView.reloadForm()
    }
}

extension BookingQuestionsViewController: FormViewDataSource {
    func formView(_ formView: FormView, titleForOption option: Int, at indexPath: IndexPath) -> String {
        let question = questionGroups![indexPath.section].questions[indexPath.row]
        
        switch question.type {
        case .multipleChoice(let choices):
            return choices[option].value
        default:
            return ""
        }
    }

    func formView(_ formView: FormView, numberOfOptionsForInputAt indexPath: IndexPath) -> Int {
        switch questionGroups![indexPath.section].questions[indexPath.row].type {
        case .multipleChoice(let choices):
            return choices.count
        default:
            return 0
        }
    }

    func formView(_ formView: FormView, valueForInputAt indexPath: IndexPath) -> Any? {
        return nil
    }

    func formView(_ formView: FormView, inputDescriptorForFieldAt indexPath: IndexPath) -> InputDescriptor {
        return InputDescriptor(question: questionGroups![indexPath.section].questions[indexPath.row])
    }

    func numberOfSections(in formView: FormView) -> Int {
        return questionGroups?.count ?? 0
    }

    func formView(_ formView: FormView, numberOfFieldsIn section: Int) -> Int {
        return questionGroups![section].questions.count
    }
}

extension BookingQuestionsViewController: FormViewDelegate {
    func formView(_ formView: FormView, disclaimerForHeaderIn secion: Int) -> String? {
        return questionGroups?[secion].disclaimer
    }

    func formView(_ formView: FormView, titleForHeaderIn secion: Int) -> String? {
        return questionGroups?[secion].title
    }

    func formView(_ formView: FormView, didChangeValue value: Any?, forInputFieldAt indexPath: IndexPath) {

    }
}

extension InputDescriptor {
    init(question: Question) {
        self.init(identifier: question.id, type: question.type.inputType, label: question.value)
    }
}

extension Question.`Type` {
    var inputType: InputType {
        switch self {
        case .string:
            return .string
        case .multipleChoice:
            return .list
        }
    }
}
