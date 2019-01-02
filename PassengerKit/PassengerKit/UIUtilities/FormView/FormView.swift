//
//  FormView.swift
//  PassengerKit
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
    func formView(_ formView: FormView, titleForHeaderIn secion: Int) -> String?
    func formView(_ formView: FormView, disclaimerForHeaderIn section: Int) -> String?
}

extension FormViewDelegate {
    func formView(_ formView: FormView, sizeForInputFieldAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: formView.bounds.width, height: 44)
    }
}

public class FormView: UIView {
    public weak var dataSource: FormViewDataSource?
    public weak var delegate: FormViewDelegate?

    private weak var collectionView: UICollectionView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let bundle = Bundle(for: type(of: self))

        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear

        self.collectionView = collectionView

        addSubview(collectionView)
        addConstraints([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor)
            ])

        register(UINib(nibName: "FormStringCell", bundle: bundle), forInputWithType: .string)
        register(UINib(nibName: "FormListCell", bundle: bundle), forInputWithType: .list)

        collectionView.register(UINib(nibName: "FormHeaderView", bundle: bundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader")
    }

    public func register(_ nib: UINib?, forInputWithType inputType: InputType) {
        collectionView.register(nib, forCellWithReuseIdentifier: inputType.cellIdentifier)
    }

    public func reloadForm() {
        collectionView.reloadData()
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
            cell.dataSource = self
            cell.reload()
            return cell
        }
    }
}

extension FormView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return delegate?.formView(self, sizeForInputFieldAt: indexPath) ?? .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let title = delegate?.formView(self, titleForHeaderIn: section) else {
            return .zero
        }

        let disclaimer = delegate?.formView(self, disclaimerForHeaderIn: section)

        return FormHeaderView.sizeFor(boundingSize: CGSize(width: collectionView.bounds.width, height: 0), title: title, disclaimer: disclaimer)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! FormHeaderView
            view.titleLabel.text = delegate?.formView(self, titleForHeaderIn: indexPath.section)
            view.disclaimerLabel.text = delegate?.formView(self, disclaimerForHeaderIn: indexPath.section)
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

extension FormView: ListInputCellDataSource {
    func numberOfOptionsInListInputCell(_ cell: FormListInputCell) -> Int {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return 0
        }

        return dataSource?.formView(self, numberOfOptionsForInputAt: indexPath) ?? 0
    }

    func listInputCell(_ cell: FormListInputCell, titleForOption option: Int) -> String? {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return nil
        }

        return dataSource?.formView(self, titleForOption: option, at: indexPath)
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
