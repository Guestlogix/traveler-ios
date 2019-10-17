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
    func formView(_ formView: FormView, disclaimerForHeaderIn section: Int) -> String?
    func formView(_ formView: FormView, didPressButtonAt indexPath: IndexPath)
    func formView(_ formView: FormView, messageForFieldAt indexPath: IndexPath) -> FormMessage?
    func formViewDidChangeContentSize(_ formView: FormView)
}

extension FormViewDelegate {
    public func formView(_ formView: FormView, sizeForInputFieldAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: formView.bounds.width, height: 50)
    }

    func formView(_ formView: FormView, didPressButtonAt indexPath: IndexPath) {
        /// Default implementation is noop
    }

    func formView(_ formView: FormView, messageForFieldAt indexPath: IndexPath) -> FormMessage? {
        return nil
    }

    public func formViewDidChangeContentSize(_ formView: FormView) {
        /// Default noop
    }

    func formView(_ formView: FormView, titleForHeaderIn section: Int) -> String? {
        return nil
    }

    func formView(_ formView: FormView, disclaimerForHeaderIn section: Int) -> String? {
        return nil
    }
}

let elementKindFieldFooter = "elementKindFieldFooter"
let errorFooterIdentifier = "errorFooterIdentifier"
let sectionHeaderIdentifier = "sectionHeaderIdentifier"

public class FormView: UIView {
    public weak var dataSource: FormViewDataSource?
    public weak var delegate: FormViewDelegate?
    public var contentSize: CGSize {
        return collectionView.collectionViewLayout.collectionViewContentSize
    }

    private weak var collectionView: UICollectionView!
    private var datePickerIndexPath: IndexPath?

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

        collectionView.register(UINib(nibName: "FormDateInputCell", bundle: bundle), forCellWithReuseIdentifier: datePickerCellIdentifier)

        register(UINib(nibName: "FormQuantityCell", bundle: bundle), forInputWithType: .quantity)
        register(UINib(nibName: "FormValueDisplayInputCell", bundle: bundle), forInputWithType: .date)
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
        collectionView.scrollToItem(at: formAdjustIndexPath(indexPath), at: .bottom, animated: animated)
    }

    public func reloadFields(at indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths.map(formAdjustIndexPath))
    }

    // MARK: Helper methods

    private func dataSourceAdjustedIndexPath(_ indexPath: IndexPath) -> IndexPath {
        let needsAdjustment = datePickerIndexPath?.section == indexPath.section && indexPath.item > datePickerIndexPath!.item
        return needsAdjustment ? IndexPath(item: indexPath.item - 1, section: indexPath.section) : indexPath
    }

    private func formAdjustIndexPath(_ indexPath: IndexPath) -> IndexPath {
        let needsAdjustment = datePickerIndexPath?.section == indexPath.section && indexPath.item >= datePickerIndexPath!.item
        return needsAdjustment ? IndexPath(item: indexPath.item + 1, section: indexPath.section) : indexPath
    }
}

extension FormView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = dataSource!.formView(self, numberOfFieldsIn: section)
        return datePickerIndexPath?.section == section ? count + 1 : count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath != datePickerIndexPath else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: datePickerCellIdentifier, for: indexPath) as! FormDateInputCell
            let valueCellIndexPath = IndexPath(item: indexPath.row - 1, section: indexPath.section)
            cell.delegate = self
            cell.datePicker.minimumDate = nil // TODO: Wait for API to implement then add to the models
            cell.datePicker.maximumDate = nil // TODO: Wait for API to implement then add to the models
            cell.datePicker.date = dataSource?.formView(self, valueForInputAt: valueCellIndexPath) as? Date ?? Date()
            cell.backgroundColor = .white
            return cell
        }

        let adjustedIndexPath = dataSourceAdjustedIndexPath(indexPath)
        let descriptor = dataSource!.formView(self, inputDescriptorForFieldAt: adjustedIndexPath)

        switch descriptor.type {
        case .quantity:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.type.cellIdentifier, for: indexPath) as! FormQuantityInputCell
            cell.stepper.value = dataSource!.formView(self, valueForInputAt: indexPath) as? Int ?? 0
            cell.label.text = descriptor.label
            cell.stepper.minimumValue = 0
            cell.stepper.maximumValue = 999
            cell.delegate = self
            return cell
        case .date:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.type.cellIdentifier, for: adjustedIndexPath) as! FormValueDisplayInputCell
            cell.label = descriptor.label

            if let value = dataSource!.formView(self, valueForInputAt: adjustedIndexPath) as? Date {
                cell.value = DateFormatter.monthAsTextFormatter.string(from: value)
            } else {
                cell.value = nil
            }

            return cell
        case .string:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.type.cellIdentifier, for: adjustedIndexPath) as! FormStringInputCell
            cell.textField.text = dataSource!.formView(self, valueForInputAt: adjustedIndexPath) as? String
            cell.label = descriptor.label
            cell.delegate = self
            return cell
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.type.cellIdentifier, for: adjustedIndexPath) as! FormListInputCell
            let selectedIndex = dataSource?.formView(self, valueForInputAt: adjustedIndexPath) as? Int
            cell.textField.text = selectedIndex.flatMap({ dataSource!.formView(self, titleForOption: $0, at: adjustedIndexPath) })
            cell.label = descriptor.label
            cell.delegate = self
            cell.items = []

            let totalItems = dataSource?.formView(self, numberOfOptionsForInputAt: adjustedIndexPath) ?? 0
            for i in 0..<totalItems {
                cell.items.append(dataSource?.formView(self, titleForOption: i, at: adjustedIndexPath))
            }

            cell.reload()
            return cell
        case .button(let title):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.type.cellIdentifier, for: adjustedIndexPath) as! FormButtonCell
            cell.button.setTitle(title, for: .normal)
            cell.delegate = self
            return cell
        }
    }
}

extension FormView: UICollectionViewDelegateFormLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath != datePickerIndexPath else {
            return CGSize(width: collectionView.bounds.width, height: 162)
        }

        return delegate?.formView(self, sizeForInputFieldAt: dataSourceAdjustedIndexPath(indexPath)) ?? .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let title = delegate?.formView(self, titleForHeaderIn: section) else {
            return .zero
        }

        let disclaimer = delegate?.formView(self, disclaimerForHeaderIn: section)

        return FormHeaderView.sizeFor(boundingSize: CGSize(width: collectionView.bounds.width - 10, height: 0), title: title, disclaimer: disclaimer)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterAt indexPath: IndexPath) -> CGSize {
        guard let message = delegate?.formView(self, messageForFieldAt: dataSourceAdjustedIndexPath(indexPath)) else {
            return .zero
        }

        return FormFieldFooterView.sizeFor(boundingSize: CGSize(width: collectionView.bounds.width, height: 0), text: message.text)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderIdentifier, for: indexPath) as! FormHeaderView
            view.titleLabel.text = delegate?.formView(self, titleForHeaderIn: indexPath.section)
            view.disclaimerLabel.text = delegate?.formView(self, disclaimerForHeaderIn: indexPath.section)
            return view
        case elementKindFieldFooter:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: errorFooterIdentifier, for: indexPath) as! FormFieldFooterView
            let message = delegate?.formView(self, messageForFieldAt: dataSourceAdjustedIndexPath(indexPath))
            view.label.text = message?.text
            view.label.textColor = message?.color
            view.label.textAlignment = message?.textAlignment ?? .left
            return view
        default:
            fatalError("Unknown suppplementary element kind: \(kind)")
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.cellForItem(at: indexPath) as? FormValueDisplayInputCell else {
            return
        }

        switch datePickerIndexPath {
        /// The picker is open and right underneath the selected cell
        case .some(let currentDateIndexPath) where currentDateIndexPath.section == indexPath.section && currentDateIndexPath.item == indexPath.item + 1:
            self.datePickerIndexPath = nil
            collectionView.deleteItems(at: [currentDateIndexPath])

        /// The picker is open and above the selected cell
        case .some(let currentDateIndexPath) where currentDateIndexPath.section == indexPath.section && indexPath.item > currentDateIndexPath.item:
            collectionView.performBatchUpdates({
                let datePickerIndexPath = indexPath
                self.datePickerIndexPath = datePickerIndexPath

                collectionView.deleteItems(at: [currentDateIndexPath])
                collectionView.insertItems(at: [datePickerIndexPath])
            }, completion: nil)

        /// The picker is open and is either in a different section or after the selected cell
        case .some(let currentDateIndexPath):
            collectionView.performBatchUpdates({
                let datePickerIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
                self.datePickerIndexPath = datePickerIndexPath

                collectionView.deleteItems(at: [currentDateIndexPath])
                collectionView.insertItems(at: [datePickerIndexPath])

            }, completion: nil)

        /// The picker is not open
        case .none:
            let datePickerIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            self.datePickerIndexPath = datePickerIndexPath
            collectionView.insertItems(at: [datePickerIndexPath])
        }

        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, contentSizeDidChangeWith collectionViewLayout: UICollectionViewLayout) {
        delegate?.formViewDidChangeContentSize(self)
    }
}

extension FormView: DateInputCellDelegate {
    func dateInputCellValueDidChange(_ cell: FormDateInputCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        let valueIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        delegate?.formView(self, didChangeValue: cell.datePicker.date, forInputFieldAt: valueIndexPath)

        collectionView.reloadItems(at: [valueIndexPath])
    }
}

extension FormView: QuantityInputCellDelegate {
    func quantityCellValueDidChange(_ cell: FormQuantityInputCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        delegate?.formView(self, didChangeValue: cell.stepper.value, forInputFieldAt: indexPath)
    }
}

extension FormView: StringInputCellDelegate {
    func stringInputCellValueDidChange(_ cell: FormStringInputCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        delegate?.formView(self, didChangeValue: cell.textField.text, forInputFieldAt: dataSourceAdjustedIndexPath(indexPath))
    }
}

extension FormView: ListInputCellDelegate {
    func listInputCell(_ cell: FormListInputCell, didSelect option: Int) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        delegate?.formView(self, didChangeValue: option, forInputFieldAt: dataSourceAdjustedIndexPath(indexPath))
    }
}

extension FormView: FormButtonCellDelegate {
    func buttonCellDidPressButton(_ cell: FormButtonCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        delegate?.formView(self, didPressButtonAt: dataSourceAdjustedIndexPath(indexPath))
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
