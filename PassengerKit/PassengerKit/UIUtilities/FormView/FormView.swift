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

        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self

        let layout = UICollectionViewFlowLayout()

        collectionView.collectionViewLayout = layout

        addSubview(collectionView)
        addConstraints([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor)
            ])

        register(UINib(nibName: "FormStringCell", bundle: bundle), forInputWithType: .string)
        register(UINib(nibName: "FormListCell", bundle: bundle), forInputWithType: .list)
    }

    public func register(_ nib: UINib?, forInputWithType inputType: InputType) {
        collectionView.register(nib, forCellWithReuseIdentifier: inputType.cellIdentifier)
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

        switch descriptor.inputType {
        case .string:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.inputType.cellIdentifier, for: indexPath) as! StringInputCell
            cell.textField.text = dataSource!.formView(self, valueForInputAt: indexPath) as? String
            cell.delegate = self
            return cell
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.inputType.cellIdentifier, for: indexPath) as! ListInputCell
            let selectedIndex = dataSource?.formView(self, valueForInputAt: indexPath) as? Int
            cell.textField.text = selectedIndex.flatMap({ dataSource!.formView(self, titleForOption: $0, at: indexPath) })
            cell.delegate = self
            cell.dataSource = self
            return cell
        }
    }
}

extension FormView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return delegate?.formView(self, sizeForInputFieldAt: indexPath) ?? .zero
    }
}

extension FormView: StringInputCellDelegate {
    func stringInputCellValueDidChange(_ cell: StringInputCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        delegate?.formView(self, didChangeValue: cell.textField.text, forInputFieldAt: indexPath)
    }
}

extension FormView: ListInputCellDataSource {
    func numberOfOptionsInListInputCell(_ cell: ListInputCell) -> Int {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return 0
        }

        return dataSource?.formView(self, numberOfOptionsForInputAt: indexPath) ?? 0
    }

    func listInputCell(_ cell: ListInputCell, titleForOption option: Int) -> String? {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return nil
        }

        return dataSource?.formView(self, titleForOption: option, at: indexPath)
    }
}

extension FormView: ListInputCellDelegate {
    func listInputCell(_ cell: ListInputCell, didSelect option: Int) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        delegate?.formView(self, didChangeValue: option, forInputFieldAt: indexPath)
    }
}
