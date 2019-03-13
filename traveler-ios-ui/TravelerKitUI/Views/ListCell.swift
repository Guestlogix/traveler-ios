//
//  ListCell.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-30.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

protocol ListCellDataSource: class {
    func numberOfRowsInListCell(_ cell: ListCell) -> Int
    func listCell(_ cell: ListCell, titleForRow row: Int) -> String?
}

protocol ListCellDelegate: class {
    func listCell(_ cell: ListCell, didSelectRow row: Int)
}

class ListCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    weak var dataSource: ListCellDataSource?
    weak var delegate: ListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self

        textField.inputView = pickerView
    }

    @IBAction func didBeginEditing(_ sender: UITextField) {
        guard let dataSource = dataSource, (sender.text == nil || sender.text == "") && dataSource.numberOfRowsInListCell(self) > 0 else {
            return
        }

        textField.text = dataSource.listCell(self, titleForRow: 0)
        delegate?.listCell(self, didSelectRow: 0)
    }
}

extension ListCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.numberOfRowsInListCell(self) ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource?.listCell(self, titleForRow: row)
    }
}

extension ListCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = dataSource?.listCell(self, titleForRow: row)
        delegate?.listCell(self, didSelectRow: row)
    }
}

extension ListCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
