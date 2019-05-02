//
//  ReceiptViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

class ReceiptViewController: UITableViewController {
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    var receipt: Receipt?

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Add back confirmation number label after backend figures out how to send us an ORDER confirmation number

        //confirmationLabel.text = receipt?.order.referenceNumber
        emailLabel.text = receipt?.order.email.email
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipt?.order.products.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath) as! InfoCell
        let product = receipt!.order.products[indexPath.row]
        cell.titleLabel.text = product.title
        // TODO: Add booking date once the backend is sending it
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let product = receipt!.order.products[indexPath.row]
        return InfoCell.boundingSize(title: product.title, value: "", with: tableView.bounds.size).height
    }
}
