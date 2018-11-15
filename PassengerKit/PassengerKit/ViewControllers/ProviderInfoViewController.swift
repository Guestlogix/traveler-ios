//
//  ProviderInfoViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol ProviderInfoViewControllerDelegate: class {
    func providerInfoViewControllerDidChangePreferredContentSize(_ controller: ProviderInfoViewController)
}

let locationCellIdentifier = "locationCellIdentifier"

class ProviderInfoViewController: UIViewController {
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    var contactInfo: ContactInfo?
    var locations: [Location]?
    weak var delegate: ProviderInfoViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = contactInfo?.name
        emailButton.setTitle(contactInfo?.email, for: .normal)
        websiteButton.setTitle(contactInfo?.website, for: .normal)
        phoneButton.setTitle(contactInfo?.phones?.first, for: .normal)

        contactView.isHidden = contactInfo == nil
        locationView.isHidden = locations?.isEmpty ?? true
        emailView.isHidden = contactInfo?.email == nil
        websiteView.isHidden = contactInfo?.website == nil
        phoneButton.isHidden = contactInfo?.phones?.isEmpty ?? true

        // Calculate size

        if let locations = locations {
            var tableViewHeight: CGFloat = 0

            for i in 0..<locations.count {
                tableViewHeight += tableView(tableView, heightForRowAt: IndexPath(row: i, section: 0))
            }

            tableViewHeightConstraint.constant = tableViewHeight
        }

        let size = view.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0),
                                                withHorizontalFittingPriority: .required,
                                                verticalFittingPriority: .defaultLow)

        self.preferredContentSize = size

        delegate?.providerInfoViewControllerDidChangePreferredContentSize(self)
    }

    // MARK: Actions

    @IBAction func didPressEmailButton(_ sender: UIButton) {
        guard let email = contactInfo?.email, let url = URL(string: "mailto:\(email)") else {
            Log("Invalid email url", data: contactInfo?.email, level: .error)
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func didPressWebsiteButton(_ sender: UIButton) {
        guard let website = contactInfo?.website, let url = URL(string: website) else {
            Log("Invalid website url", data: contactInfo?.website, level: .error)
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func didPressPhoneButton(_ sender: UIButton) {
        guard let phone = contactInfo?.phones?.first, let url = URL(string: "tel:\(phone)") else {
            Log("Invalid phone url", data: contactInfo?.phones, level: .error)
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension ProviderInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellIdentifier, for: indexPath) as! LocationCell
        let location = locations![indexPath.row]
        cell.addressLabel.text = location.address
        cell.delegate = self
        return cell
    }
}

extension ProviderInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let location = locations![indexPath.row]
        return LocationCell.boundingSize(address: location.address, with: CGSize(width: tableView.bounds.width, height: 0)).height
    }
}

extension ProviderInfoViewController: LocationCellDelegate {
    func locationCellDidPressMapsButton(_ cell: LocationCell) {
        
    }
}
