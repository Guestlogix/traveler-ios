//
//  FormView.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

public protocol FormViewDataSource: class {
    func numberOfSections(in formView: FormView) -> Int
    func formView(_ formView: FormView, numberOfFieldsIn section: Int) -> Int
    func formView(_ formView: FormView, inputDescriptorForFieldAt indexPath: IndexPath) -> InputDescriptor
    func formView(_ formView: FormView, valueForInputAt indexPath: IndexPath) -> Any?
    func formView(_ formView: FormView, numberOfOptionsForInputAt indexPath: IndexPath) -> Int
    func formView(_ formView: FormView, titleForOption option: Int, at indexPath: IndexPath) -> String
}

public protocol FormViewDelegate: class {
    func formView(_ formView: FormView, didChangeValue value: Any?, forInputFieldAt indexPath: IndexPath)
    func formView(_ formView: FormView, sizeForInputFieldAt indexPath: IndexPath) -> CGSize
    func formView(_ formView: FormView, titleForHeaderIn section: Int) -> String?
    func formView(_ formView: FormView, descriptionForHeaderIn section: Int) -> String?
    func formView(_ formView: FormView, didPressButtonAt indexPath: IndexPath)
    func formView(_ formView: FormView, messageForFieldAt indexPath: IndexPath) -> FormMessage?
}

extension FormViewDelegate {
    func formView(_ formView: FormView, sizeForInputFieldAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: formView.bounds.width, height: 50)
    }

    func formView(_ formView: FormView, didPressButtonAt indexPath: IndexPath) {
        /// Default implementation is noop
    }

    func formView(_ formView: FormView, messageForFieldAt indexPath: IndexPath) -> FormMessage? {
        return nil
    }
}

let elementKindFieldFooter = "elementKindFieldFooter"
let errorFooterIdentifier = "errorFooterIdentifier"
let sectionHeaderIdentifier = "sectionHeaderIdentifier"

public class FormView: UIView {
    public weak var dataSource: FormViewDataSource?
    public weak var delegate: FormViewDelegate?

    private weak var collectionView: UICollectionView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let bundle = Bundle(for: type(of: self))

        let layout = FormLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .interactive

        self.collectionView = collectionView

        addSubview(collectionView)
        addConstraints([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor)
            ])

        register(UINib(nibName: "FormStringCell", bundle: bundle), forInputWithType: .string)
        register(UINib(nibName: "FormListCell", bundle: bundle), forInputWithType: .list)
        register(UINib(nibName: "FormButtonCell", bundle: bundle), forInputWithType: .button(nil))

        /// TODO: Refactor and make public methods to expose this feature

        collectionView.register(UINib(nibName: "FormHeaderView", bundle: bundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderIdentifier)
        collectionView.register(UINib(nibName: "FormFieldFooterView", bundle: bundle), forSupplementaryViewOfKind: elementKindFieldFooter, withReuseIdentifier: errorFooterIdentifier)
    }

    public func register(_ nib: UINib?, forInputWithType inputType: InputType) {
        collectionView.register(nib, forCellWithReuseIdentifier: inputType.cellIdentifier)
    }

    public func reloadForm() {
        collectionView.reloadData()
    }

    public func scrollToField(at indexPath: IndexPath, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }

    public func reloadFields(at indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
}

extension FormView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource!.formView(self, numberOfFieldsIn: section)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let descriptor = dataSource!.formView(self, inputDescriptorForFieldAt: indexPath)

        switch descriptor.type {
        case .string:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.type.cellIdentifier, for: indexPath) as! FormStringInputCell
            cell.textField.text = dataSource!.formView(self, valueForInputAt: indexPath) as? String
            cell.textField.placeholder = descriptor.label
            cell.delegate = self
            return cell
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.type.cellIdentifier, for: indexPath) as! FormListInputCell
            let selectedIndex = dataSource?.formView(self, valueForInputAt: indexPath) as? Int
            cell.textField.text = selectedIndex.flatMap({ dataSource!.formView(self, titleForOption: $0, at: indexPath) })
            cell.textField.placeholder = descriptor.label
            cell.delegate = self
            cell.items = []

            let totalItems = dataSource?.formView(self, numberOfOptionsForInputAt: indexPath) ?? 0
            for i in 0..<totalItems {
                cell.items.append(dataSource?.formView(self, titleForOption: i, at: indexPath))
            }

            cell.reload()
            return cell
        case .button(let title):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.type.cellIdentifier, for: indexPath) as! FormButtonCell
            cell.button.setTitle(title, for: .normal)
            cell.delegate = self
            return cell
        }
    }
}

extension FormView: UICollectionViewDelegateFormLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return delegate?.formView(self, sizeForInputFieldAt: indexPath) ?? .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let title = delegate?.formView(self, titleForHeaderIn: section) else {
            return .zero
        }

        let description = delegate?.formView(self, descriptionForHeaderIn: section)

        return FormHeaderView.sizeFor(boundingSize: CGSize(width: collectionView.bounds.width - 10, height: 0), title: title, description: description)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterAt indexPath: IndexPath) -> CGSize {
        guard let message = delegate?.formView(self, messageForFieldAt: indexPath) else {
            return .zero
        }

        return FormFieldFooterView.sizeFor(boundingSize: CGSize(width: collectionView.bounds.width, height: 0), text: message.text)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderIdentifier, for: indexPath) as! FormHeaderView
            view.titleLabel.text = delegate?.formView(self, titleForHeaderIn: indexPath.section)
            view.descriptionLabel.text = delegate?.formView(self, descriptionForHeaderIn: indexPath.section)
            return view
        case elementKindFieldFooter:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: errorFooterIdentifier, for: indexPath) as! FormFieldFooterView
            let message = delegate?.formView(self, messageForFieldAt: indexPath)
            view.label.text = message?.text
            view.label.textColor = message?.color
            view.label.textAlignment = message?.textAlignment ?? .left
            return view
        default:
            fatalError("Unknown suppplementary element kind: \(kind)")
        }
    }
}

extension FormView: StringInputCellDelegate {
    func stringInputCellValueDidChange(_ cell: FormStringInputCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        delegate?.formView(self, didChangeValue: cell.textField.text, forInputFieldAt: indexPath)
    }
}

extension FormView: ListInputCellDelegate {
    func listInputCell(_ cell: FormListInputCell, didSelect option: Int) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        delegate?.formView(self, didChangeValue: option, forInputFieldAt: indexPath)
    }
}

extension FormView: FormButtonCellDelegate {
    func buttonCellDidPressButton(_ cell: FormButtonCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        delegate?.formView(self, didPressButtonAt: indexPath)
    }
}

extension FormMessage {
    var color: UIColor {
        switch self {
        case .alert:
            return .red
        default:
            return .black
        }
    }

    var textAlignment: NSTextAlignment {
        switch self {
        case .alert:
            return .right
        default:
            return .left
        }
    }
}
