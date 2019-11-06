//
//  PurchaseQuestionsViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-31.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit


public protocol PurchaseQuestionsViewControllerDelegate: class {
    func purchaseQuestionsViewController(_ controller: PurchaseQuestionsViewController, didCheckoutWith purchaseForm: PurchaseForm)
}

open class PurchaseQuestionsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var formView: FormView!

    var purchaseForm: PurchaseForm?
    weak var delegate: PurchaseQuestionsViewControllerDelegate?
    private var error: Error?

    override open func viewDidLoad() {
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

        self.view.layoutIfNeeded()
    }
}

extension PurchaseQuestionsViewController: FormViewDataSource {
    public func formView(_ formView: FormView, titleForOption option: Int, at indexPath: IndexPath) -> String {
        let question = purchaseForm!.questionGroups[indexPath.section].questions[indexPath.row]
        
        switch question.type {
        case .multipleChoice(let choices):
            return choices[option].value
        default:
            return ""
        }
    }

    public func formView(_ formView: FormView, numberOfOptionsForInputAt indexPath: IndexPath) -> Int {
        switch purchaseForm!.questionGroups[indexPath.section].questions[indexPath.row].type {
        case .multipleChoice(let choices):
            return choices.count
        default:
            return 0
        }
    }

    public func formView(_ formView: FormView, valueForInputAt indexPath: IndexPath) -> Any? {
        let question = purchaseForm!.questionGroups[indexPath.section].questions[indexPath.row]
        let answer = try? purchaseForm!.answer(for: question)

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

    public func formView(_ formView: FormView, inputDescriptorForFieldAt indexPath: IndexPath) -> InputDescriptor {
        switch indexPath.section {
        case purchaseForm!.questionGroups.count:
            return InputDescriptor(type: .button("Checkout"))
        default:
            return InputDescriptor(question: purchaseForm!.questionGroups[indexPath.section].questions[indexPath.row])
        }
    }

    public func numberOfSections(in formView: FormView) -> Int {
        return purchaseForm.flatMap({ $0.questionGroups.count + 1 }) ?? 0
    }

    public func formView(_ formView: FormView, numberOfFieldsIn section: Int) -> Int {
        switch section {
        case purchaseForm!.questionGroups.count:
            return 1
        default:
            return purchaseForm!.questionGroups[section].questions.count
        }
    }
}

extension PurchaseQuestionsViewController: FormViewDelegate {
    public func formView(_ formView: FormView, disclaimerForHeaderIn section: Int) -> String? {
        guard section < purchaseForm!.questionGroups.count else {
            return nil
        }

        return purchaseForm?.questionGroups[section].disclaimer
    }

    public func formView(_ formView: FormView, titleForHeaderIn section: Int) -> String? {
        guard section < purchaseForm!.questionGroups.count else {
            return nil
        }

        return purchaseForm?.questionGroups[section].title
    }

    public func formView(_ formView: FormView, didChangeValue value: Any?, forInputFieldAt indexPath: IndexPath) {
        let question = purchaseForm!.questionGroups[indexPath.section].questions[indexPath.row]

        switch (question.type, value) {
        case (.date, let value as Date):
            try? purchaseForm!.addAnswer(DateAnswer(value, question: question))
        case (.quantity, let value as Int):
            try? purchaseForm!.addAnswer(QuantityAnswer(value, question: question))
        case (.string, let value as String):
            try? purchaseForm!.addAnswer(TextualAnswer(value, question: question))
        case (.multipleChoice(let choices), let value as Int) where value < choices.count:
            try? purchaseForm!.addAnswer(MultipleChoiceSelection(value, question: question))
        default:
            Log("Invalid answer", data: value, level: .error)
            break
        }
    }

    public func formView(_ formView: FormView, didPressButtonAt indexPath: IndexPath) {
        /// There is only one button: Checkout

        let errors = purchaseForm?.validate()

        switch errors?.first {
        case .none:
            delegate?.purchaseQuestionsViewController(self, didCheckoutWith: purchaseForm!)
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

    public func formView(_ formView: FormView, messageForFieldAt indexPath: IndexPath) -> FormMessage? {
        guard let error = self.error as? PurchaseFormError,
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
