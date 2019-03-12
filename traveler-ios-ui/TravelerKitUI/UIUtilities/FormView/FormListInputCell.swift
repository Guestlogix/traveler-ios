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

class FormListInputCell: UICollectionViewCell {
    @IBOutlet weak var textField: UITextField!

    weak var delegate: ListInputCellDelegate?

    var items = [String?]()

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

    @IBAction func didBeginEditing(_ sender: UITextField) {
        guard (sender.text == nil || sender.text == "") && items.count > 0 else {
            return
        }

        sender.text = items[0]
        delegate?.listInputCell(self, didSelect: 0)
    }
}

extension FormListInputCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
}

extension FormListInputCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = items[row]
        delegate?.listInputCell(self, didSelect: row)
    }
}
