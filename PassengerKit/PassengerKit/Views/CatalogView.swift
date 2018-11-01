//
//  CatalogView.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-10-29.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

@objc
public protocol CatalogViewDataSouce: class {
    func numberOfGroups(in catalogView: CatalogView) -> Int
    func catalogView(_ catalogView: CatalogView, numberOfItemsIn group: Int) -> Int
    func catalogView(_ catalogView: CatalogView, configure itemCell: CarouselItemViewCell, at indexPath: IndexPath)
    func catalogView(_ catalogView: CatalogView, titleForHeaderIn group: Int) -> String?
    func catalogView(_ catalogView: CatalogView, titleForAccessoryButtonIn group: Int) -> String?
}

extension CatalogViewDataSouce {
    func catalogView(_ catalogView: CatalogView, titleForHeaderIn group: Int) -> String? {
        return nil
    }

    func catalogView(_ catalogView: CatalogView, titleForAccessoryButtonIn group: Int) -> String? {
        return nil
    }
}

@objc
public protocol CatalogViewDelegate: class {
    func catalogView(_ catalogView: CatalogView, heightForHeaderIn group: Int) -> CGFloat
    func catalogView(_ catalogView: CatalogView, heightForItemFooterIn group: Int) -> CGFloat
    func catalogView(_ catalogView: CatalogView, sizeForItemsIn group: Int) -> CGSize
    func catalogView(_ catalogView: CatalogView, spacingBetweenItemsIn group: Int) -> CGFloat
    func catalogView(_ catalogView: CatalogView, didPressAccessoryButtonIn group: Int)
    func catalogView(_ catalogView: CatalogView, didSelectItemAt indexPath: IndexPath)
}

extension CatalogViewDelegate {
    func catalogView(_ catalogView: CatalogView, heightForHeaderIn group: Int) -> CGFloat {
        return CarouselViewCell.headerHeight
    }

    func catalogView(_ catalogView: CatalogView, heightForItemFooterIn group: Int) -> CGFloat {
        return CarouselItemViewCell.footerHeight
    }

    func catalogView(_ catalogView: CatalogView, sizeForItemsIn group: Int) -> CGSize {
        let value: CGFloat = 60
        return CGSize(width: (value * 16.0 / 9.0), height: value)
    }

    func catalogView(_ catalogView: CatalogView, spacingBetweenItemsIn group: Int) -> CGFloat {
        return 2 * CarouselItemViewCell.margin
    }

    func catalogView(_ catalogView: CatalogView, didPressAccessoryButtonIn group: Int) {
        // noop
    }

    func catalogView(_ catalogView: CatalogView, didSelectItemAt indexPath: IndexPath) {
        // noop
    }
}

let groupCellIdentifier = "groupCellIdentifier"

public class CatalogView: UIView {
    @IBOutlet public weak var dataSource: CatalogViewDataSouce?
    @IBOutlet public weak var delegate: CatalogViewDelegate?

    @IBInspectable public var maxNumberOfCardsPerGroup = 5

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CarouselViewCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: groupCellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false

        addSubview(tableView)

        addConstraints([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor)
            ])
    }
}

extension CatalogView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfGroups(in: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: groupCellIdentifier, for: indexPath) as! CarouselViewCell

        cell.dataSource = self
        cell.delegate = self
        cell.headerLabel.text = dataSource?.catalogView(self, titleForHeaderIn: indexPath.row)

        if let accessoryTitle = dataSource?.catalogView(self, titleForAccessoryButtonIn: indexPath.row) {
            cell.moreButton.isHidden = false
            cell.moreButton.setTitle(accessoryTitle, for: .normal)
        } else {
            cell.moreButton.isHidden = true
        }

        cell.reload()
        cell.tag = indexPath.row

        return cell
    }
}

extension CatalogView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemHeight = (delegate?.catalogView(self, sizeForItemsIn: indexPath.row).height ?? 0.0)
        let margin: CGFloat = 20.0 //(delegate?.catalogView(self, spacingBetweenItemsIn: indexPath.row) ?? 0.0)
        let headerHeight = (delegate?.catalogView(self, heightForHeaderIn: indexPath.row) ?? 0.0)
        let itemFooterHeight = (delegate?.catalogView(self, heightForItemFooterIn: indexPath.row) ?? 0.0)

        return itemHeight + margin + headerHeight + itemFooterHeight
    }
}

extension CatalogView: CarouselViewCellDelegate {
    public func carouselCellDidPressMoreButton(_ cell: CarouselViewCell) {
        delegate?.catalogView(self, didPressAccessoryButtonIn: cell.tag)
    }

    public func sizeForItemsInCell(_ cell: CarouselViewCell) -> CGSize {
        return delegate?.catalogView(self, sizeForItemsIn: cell.tag) ?? .zero
    }

    public func carouselCell(_ cell: CarouselViewCell, didSelectItemAt index: Int) {
        delegate?.catalogView(self, didSelectItemAt: IndexPath(row: index, section: cell.tag))
    }
}

extension CatalogView: CarouselViewCellDataSource {
    public func numberOfItemsInCell(_ cell: CarouselViewCell) -> Int {
        return dataSource?.catalogView(self, numberOfItemsIn: cell.tag) ?? 0
    }

    public func carouselCell(_ cell: CarouselViewCell, configure itemCell: CarouselItemViewCell, at index: Int) {
        dataSource!.catalogView(self, configure: itemCell, at: IndexPath(item: index, section: cell.tag))
    }
}
