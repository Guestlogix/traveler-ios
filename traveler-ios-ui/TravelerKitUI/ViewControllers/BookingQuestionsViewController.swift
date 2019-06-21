//
//  BookingQuestionsViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-31.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

protocol BookingQuestionsViewControllerDelegate: class {
    func bookingQuestionsViewControllerDidCheckout(_ controller: BookingQuestionsViewController)
}

class BookingQuestionsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var formView: FormView!

    var bookingForm: BookingForm?
    weak var delegate: BookingQuestionsViewControllerDelegate?

    private var error: Error?

    override func viewDidLoad() {
        super.viewDidLoad()

        formView.dataSource = self
        formView.delegate = self
        formView.reloadForm()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc
    func keyboardWillChangeFrame(_ note: Notification) {
        guard let keyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let viewControllerInView = view.convert(self.view.frame, from: nil)
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let bottomInset = viewControllerInView.intersection(keyboardFrameInView).height
        
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
}

extension BookingQuestionsViewController: FormViewDataSource {
    func formView(_ formView: FormView, titleForOption option: Int, at indexPath: IndexPath) -> String {
        let question = bookingForm!.questionGroups[indexPath.section].questions[indexPath.row]
        
        switch question.type {
        case .multipleChoice(let choices):
            return choices[option].value
        default:
            return ""
        }
    }

    func formView(_ formView: FormView, numberOfOptionsForInputAt indexPath: IndexPath) -> Int {
        switch bookingForm!.questionGroups[indexPath.section].questions[indexPath.row].type {
        case .multipleChoice(let choices):
            return choices.count
        default:
            return 0
        }
    }

    func formView(_ formView: FormView, valueForInputAt indexPath: IndexPath) -> Any? {
        let question = bookingForm!.questionGroups[indexPath.section].questions[indexPath.row]
        let answer = try? bookingForm!.answer(for: question)

        switch answer {
        case .some(let date as DateAnswer):
            return date.value
        case .some(let quantity as QuantityAnswer):
            return quantity.value
        case .some(let selection as MultipleChoiceSelection):
            return selection.value
        case .some(let answer as TextualAnswer):
            return answer.value
        default:
            return nil
        }
    }

    func formView(_ formView: FormView, inputDescriptorForFieldAt indexPath: IndexPath) -> InputDescriptor {
        switch indexPath.section {
        case bookingForm!.questionGroups.count:
            return InputDescriptor(type: .button("Checkout"))
        default:
            return InputDescriptor(question: bookingForm!.questionGroups[indexPath.section].questions[indexPath.row])
        }
    }

    func numberOfSections(in formView: FormView) -> Int {
        return bookingForm.flatMap({ $0.questionGroups.count + 1 }) ?? 0
    }

    func formView(_ formView: FormView, numberOfFieldsIn section: Int) -> Int {
        switch section {
        case bookingForm!.questionGroups.count:
            return 1
        default:
            return bookingForm!.questionGroups[section].questions.count
        }
    }
}

extension BookingQuestionsViewController: FormViewDelegate {
    func formView(_ formView: FormView, disclaimerForHeaderIn section: Int) -> String? {
        guard section < bookingForm!.questionGroups.count else {
            return nil
        }

        return bookingForm?.questionGroups[section].disclaimer
    }

    func formView(_ formView: FormView, titleForHeaderIn section: Int) -> String? {
        guard section < bookingForm!.questionGroups.count else {
            return nil
        }

        return bookingForm?.questionGroups[section].title
    }

    func formView(_ formView: FormView, didChangeValue value: Any?, forInputFieldAt indexPath: IndexPath) {
        let question = bookingForm!.questionGroups[indexPath.section].questions[indexPath.row]

        switch (question.type, value) {
        case (.date, let value as Date):
            try? bookingForm!.addAnswer(DateAnswer(value, question: question))
        case (.quantity, let value as Int):
            try? bookingForm!.addAnswer(QuantityAnswer(value, question: question))
        case (.string, let value as String):
            try? bookingForm!.addAnswer(TextualAnswer(value, question: question))
        case (.multipleChoice(let choices), let value as Int) where value < choices.count:
            try? bookingForm!.addAnswer(MultipleChoiceSelection(value, question: question))
        default:
            Log("Invalid answer", data: value, level: .error)
            break
        }
    }

    func formView(_ formView: FormView, didPressButtonAt indexPath: IndexPath) {
        /// There is only one button: Checkout

        let errors = bookingForm?.validate()

        switch errors?.first {
        case .none:
            delegate?.bookingQuestionsViewControllerDidCheckout(self)
        case .some(.invalidAnswer(let groupIndex, let questionIndex, _)):
            self.error = errors?.first

            let indexPath = IndexPath(item: questionIndex, section: groupIndex)
            formView.reloadFields(at: [indexPath])
            formView.scrollToField(at: indexPath, animated: true)
        case .some(let error):
            Log("Unknown error", data: error, level: .error)
            break
        }
    }

    func formView(_ formView: FormView, messageForFieldAt indexPath: IndexPath) -> FormMessage? {
        guard let error = self.error as? BookingFormError,
            case let .invalidAnswer(groupIndex, questionIndex, validationError) = error,
            indexPath.section == groupIndex, indexPath.item == questionIndex else {
                return nil
        }

        switch validationError {
        case .invalidFormat:
            return .alert("Invalid format")
        case .required:
            return .alert("Required")
        }

    }
}

extension InputDescriptor {
    init(question: Question) {
        self.init(type: question.type.inputType, label: question.title)
    }
}

extension Question.`Type` {
    var inputType: InputType {
        switch self {
        case .date:
            return .date
        case .quantity:
            return .quantity
        case .string:
            return .string
        case .multipleChoice:
            return .list
        }
    }
}
