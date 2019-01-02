//
//  ListInputCell.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-20.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol ListInputCellDelegate: class {
    func listInputCell(_ cell: FormListInputCell, didSelect option: Int)
}

protocol ListInputCellDataSource: class {
    func numberOfOptionsInListInputCell(_ cell: FormListInputCell) -> Int
    func listInputCell(_ cell: FormListInputCell, titleForOption option: Int) -> String?
}

class FormListInputCell: UICollectionViewCell {
    @IBOutlet weak var textField: UITextField!

    weak var dataSource: ListInputCellDataSource?
    weak var delegate: ListInputCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self

        textField.inputView = pickerView
    }

    func reload() {
        guard let pickerView = textField.inputView as? UIPickerView else {
            return
        }

        pickerView.reloadAllComponents()
    }
}

extension FormListInputCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.numberOfOptionsInListInputCell(self) ?? 0
    }
}

extension FormListInputCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource?.listInputCell(self, titleForOption: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = dataSource?.listInputCell(self, titleForOption: row)
        delegate?.listInputCell(self, didSelect: row)
    }
}
