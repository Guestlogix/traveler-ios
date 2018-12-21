//
//  ListInputCell.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-20.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol ListInputCellDelegate: class {
    func listInputCell(_ cell: ListInputCell, didSelect option: Int)
}

protocol ListInputCellDataSource: class {
    func numberOfOptionsInListInputCell(_ cell: ListInputCell) -> Int
    func listInputCell(_ cell: ListInputCell, titleForOption option: Int) -> String?
}

class ListInputCell: UICollectionViewCell {
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

extension ListInputCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.numberOfOptionsInListInputCell(self) ?? 0
    }
}

extension ListInputCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource?.listInputCell(self, titleForOption: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.listInputCell(self, didSelect: row)
    }
}
